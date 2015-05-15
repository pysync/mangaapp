//
//  ChapterListService.m
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterListService.h"
#import "ResponseModel.h"
#import <AFNetworking/AFNetworking.h>
#import "Definition.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "Chapter.h"
#import "ChapterJSONModel.h"
#import "Common.h"
#import "ChapterModel.h"
#import "AppDelegate.h"

@interface ChapterListService()

@property(nonatomic, assign) NSInteger numberImageDownloaded;
@property(nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation ChapterListService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listChapters = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"downloadInBackgroundMode"];
        configuration.HTTPMaximumConnectionsPerHost = 15;
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return self;
}

- (void)getDataFromJSONSuccess:(void (^)())successBlock failure:(void (^)())failBlock {
    NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"define" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:pathFile encoding:NSUTF8StringEncoding error:nil];
    
    NSError* err = nil;
    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:jsonString error:&err];
    if (!err) {
        _listChapters = [self createChapterModelWithData:responseModel.data];
        [self createAndSaveDataIfNeed];
        [self loadConfigFile];
        if (successBlock) {
            successBlock();
        }
    }else {
        if (failBlock) {
            failBlock();
        }
    }
}

- (NSMutableArray *)createChapterModelWithData:(NSArray *)dataArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<dataArray.count; i++) {
        ChapterJSONModel *jsonModel = (ChapterJSONModel *)dataArray[i];
        ChapterModel *chapModel = [[ChapterModel alloc] init];
        chapModel.chapterJSONModel = jsonModel;
        [resultArray addObject:chapModel];
    }
    
    return resultArray;
}

- (void)downloadChapterWithModel:(ChapterJSONModel *)chapterModel success:(void (^)())successBlock failure:(void (^)())failBlock {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _numberImageDownloaded = 0;
    NSString *baseURL = kBaseUrl;
    for (int i=0; i<chapterModel.images.count; i++) {
        if (![self imageDownloadedWithImageName:chapterModel.images[i]]) {
            NSString *fullURL = [baseURL stringByAppendingPathComponent:chapterModel.images[i]];
            NSURL *URL = [NSURL URLWithString:fullURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
                _numberImageDownloaded++;
                
                // Push notification
                NSString *pathString = filePath.absoluteString;
                NSString *imageName = [pathString lastPathComponent];
                [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownloadAnImage object:nil userInfo:@{kImageNameNotification: imageName}];
                
                if (_numberImageDownloaded == chapterModel.images.count) {
                    NSLog(@"All file download successfully");
                    if (appDelegate.backgroundTransferCompletionHandler != nil) {
                        // Copy locally the completion handler.
                        void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                        
                        // Make nil the backgroundTransferCompletionHandler.
                        appDelegate.backgroundTransferCompletionHandler = nil;
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            // Call the completion handler to tell the system that there are no other background transfers.
                            completionHandler();
                        }];
                    }
                    
                    if (successBlock) {
                        successBlock();
                    }
                }
            }];
            [downloadTask resume];
        }else {
            _numberImageDownloaded++;
            
            if (_numberImageDownloaded == chapterModel.images.count) {
                if (successBlock) {
                    successBlock();
                }
            }
        }
    }
}

- (BOOL )imageDownloadedWithImageName:(NSString *)imageName {
    NSString *documentPath = [Common getDocumentDirectory];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:imageName];
    return [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
}

- (void)createAndSaveDataIfNeed {
    NSArray *listChapter = [Chapter MR_findAllSortedBy:@"chapterNumber" ascending:YES];
    if (listChapter.count) {
        for (int i=0; i<listChapter.count; i++) {
            Chapter *chapEntity = listChapter[i];
            ChapterModel *chapModel = (ChapterModel *)_listChapters[i];
            chapModel.chapterEntity = chapEntity;
            chapModel.isFinishedDownload = chapEntity.isDownloaded.boolValue;
        }
    }else {
        for (int i=0; i<_listChapters.count; i++) {
            ChapterModel *chapModel = _listChapters[i];
            ChapterJSONModel *chap = chapModel.chapterJSONModel;
            
            Chapter *chapEntity = [Chapter MR_createEntity];
            chapEntity.chapterTitle = chap.titleChap;
            chapEntity.isDownloaded = @(0);
            chapEntity.chapterNumber = @(i+1);
            chapModel.chapterEntity = chapEntity;
            
            [chapEntity.managedObjectContext MR_saveToPersistentStoreAndWait];
        }
    }
}

- (void)loadConfigFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"staminaConfig" ofType:@"plist"];
    NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    for (int i=0; i<_listChapters.count; i++) {
        ChapterModel *chapModel = _listChapters[i];
        NSString *keyString = [NSString stringWithFormat:@"chap_%d", i+1];
        NSString *configCost = configDic[keyString];
        chapModel.staminaCost = configCost.integerValue;
        chapModel.chapName = keyString;
    }
}

- (void)updateChapterWithIndexChap:(NSInteger)indexChap andState:(BOOL)isDownloaded {
    ChapterModel *chapModel = _listChapters[indexChap];
    Chapter *chapEntity = chapModel.chapterEntity;
    chapEntity.isDownloaded = @(isDownloaded);
    [chapEntity.managedObjectContext MR_saveToPersistentStoreAndWait];
}

- (void)removeChapterWithIndexChap:(NSInteger)indexChap finish:(void (^)())finishBlock {
    ChapterModel *chapModel = _listChapters[indexChap];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (int i=0; i<chapModel.chapterJSONModel.images.count; i++) {
        NSString *imageName = chapModel.chapterJSONModel.images[i];
        NSString *documentPath = [Common getDocumentDirectory];
        NSString *imagePath = [documentPath stringByAppendingPathComponent:imageName];
        
        NSError *error = nil;
        [fileManager removeItemAtPath:imagePath error:&error];
        if (error) {
            NSLog(@"Remove file fail with path: %@", imagePath);
        }else {
            NSLog(@"Remove file success");
        }
    }
    
    [self updateChapterWithIndexChap:indexChap andState:NO];
    if (finishBlock) {
        finishBlock();
    }
}

@end
