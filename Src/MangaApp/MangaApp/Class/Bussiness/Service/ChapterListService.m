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
#import "ChapterModel.h"
#import "Common.h"

@interface ChapterListService()

@property(nonatomic, assign) NSInteger numberImageDownloaded;
@end

@implementation ChapterListService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listChapters = [[NSMutableArray alloc] initWithCapacity:0];
        _listEntityChapters = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)getDataFromJSONSuccess:(void (^)())successBlock failure:(void (^)())failBlock {
    NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"define" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:pathFile encoding:NSUTF8StringEncoding error:nil];
    
    NSError* err = nil;
    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:jsonString error:&err];
    if (!err) {
        _listChapters = [responseModel.data mutableCopy];
        [self createAndSaveDataIfNeed];
        if (successBlock) {
            successBlock();
        }
    }else {
        if (failBlock) {
            failBlock();
        }
    }
}

- (void)downloadChapterWithModel:(ChapterModel *)chapterModel success:(void (^)())successBlock failure:(void (^)())failBlock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    _numberImageDownloaded = 0;
    NSString *baseURL = kBaseUrl;
    for (int i=0; i<chapterModel.images.count; i++) {
        NSString *fullURL = [baseURL stringByAppendingPathComponent:chapterModel.images[i]];
        NSURL *URL = [NSURL URLWithString:fullURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            _numberImageDownloaded++;
            
            if (_numberImageDownloaded == chapterModel.images.count) {
                if (successBlock) {
                    successBlock();
                }
            }
        }];
        [downloadTask resume];
    }
}

- (void)createAndSaveDataIfNeed {
    NSArray *listChapter = [Chapter MR_findAllSortedBy:@"chapterNumber" ascending:YES];
    if (listChapter.count) {
        _listEntityChapters = [listChapter mutableCopy];
    }else {
        for (int i=0; i<_listChapters.count; i++) {
            ChapterModel *chap = _listChapters[i];
            Chapter *chapEntity = [Chapter MR_createEntity];
            chapEntity.chapterTitle = chap.titleChap;
            chapEntity.isDownloaded = @(0);
            chapEntity.chapterNumber = @(i+1);
            [_listEntityChapters addObject:chapEntity];
            
            [chapEntity.managedObjectContext MR_saveToPersistentStoreAndWait];
        }
    }
}

- (void)updateChapterWithIndexChap:(NSInteger)indexChap andState:(BOOL)isDownloaded {
    Chapter *chapEntity = _listEntityChapters[indexChap];
    chapEntity.isDownloaded = @(isDownloaded);
    [chapEntity.managedObjectContext MR_saveToPersistentStoreAndWait];
}

- (void)removeChapterWithIndexChap:(NSInteger)indexChap finish:(void (^)())finishBlock {
    ChapterModel *chapModel = _listChapters[indexChap];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (int i=0; i<chapModel.images.count; i++) {
        NSString *imageName = chapModel.images[i];
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
    
    if (finishBlock) {
        finishBlock();
    }
}

@end
