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
#import "Chapter.h"
#import "ChapterJSONModel.h"
#import "Common.h"
#import "ChapterModel.h"
#import "AppDelegate.h"
#import "BackgroundSessionManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DownloadPhotoOperation.h"

@interface ChapterListService()

@property(nonatomic, assign) NSInteger numberImageDownloaded;
@property(nonatomic, strong) AFURLSessionManager *manager;
@property(nonatomic, strong) NSOperationQueue *photoQueue;
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
        _photoQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)getDataFromJSONSuccess:(void (^)())successBlock failure:(void (^)())failBlock {
    NSURL *jsonURL = [NSURL URLWithString:kChapterInfoURL];
    NSString *jsonString = [NSString stringWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
    
    NSError *jsonError;
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:objectData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&jsonError];
    
    NSArray *modelObjects = [ChapterJSONModel arrayOfModelsFromDictionaries:jsonObjects];
    
    if (!jsonError) {
        _listChapters = [self createChapterModelWithData:modelObjects];
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
    _numberImageDownloaded = 0;
    NSString *baseURL = [kBaseUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", chapterModel.dirPrefix, chapterModel.chapterID]];
    for (int i=0; i<chapterModel.pageCount.integerValue; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%lu.%@", chapterModel.pagePrefix, (unsigned long)i + 1, chapterModel.ext];
        if (![self imageDownloadedWithImageName:imageName andChapterModel:chapterModel]) {
            NSString *fullURL = [baseURL stringByAppendingPathComponent:imageName];
            NSURL *URL = [NSURL URLWithString:fullURL];
            DownloadPhotoOperation *photoOperation = [[DownloadPhotoOperation alloc] initWithURL:URL];
            [_photoQueue addOperation:photoOperation];
            [_photoQueue setMaxConcurrentOperationCount:5];
            
            photoOperation.didFinishDownload = ^(){
                dispatch_async(dispatch_get_main_queue(), ^{
                    _numberImageDownloaded++;
                    
                    if (_numberImageDownloaded == chapterModel.pageCount.integerValue) {
                        NSLog(@"All file download successfully");
                        if (successBlock) {
                            successBlock();
                        }
                    }
                });
            };
        }else {
            _numberImageDownloaded++;
            
            if (_numberImageDownloaded == chapterModel.pageCount.integerValue) {
                if (successBlock) {
                    successBlock();
                }
            }
        }
    }
}

- (BOOL )imageDownloadedWithImageName:(NSString *)imageName andChapterModel:(ChapterJSONModel *)chapModel{
    NSString *chapterName = [NSString stringWithFormat:@"%@%@", chapModel.dirPrefix, chapModel.chapterID];
    NSString *documentPath = [Common getChapterDirectoryWithChapter:chapterName];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:imageName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
}

- (void)createAndSaveDataIfNeed {
    NSArray *listChapter = [Chapter MR_findAllSortedBy:@"chapterID" ascending:YES];
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
            
            Chapter *chapEntity = [Chapter MR_createEntityWithJSONModel:chap];
            chapModel.chapterEntity = chapEntity;
            
            [chapEntity.managedObjectContext MR_saveToPersistentStoreAndWait];
        }
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
    
    NSString *chapterName = [NSString stringWithFormat:@"%@%@", chapModel.chapterEntity.dirPrefix, chapModel.chapterEntity.chapterID];
    NSString *documentPath = [Common getChapterDirectoryWithChapter:chapterName];
    for (int i=0; i<chapModel.chapterJSONModel.pageCount.integerValue; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%lu.%@", chapModel.chapterJSONModel.pagePrefix, (unsigned long)i + 1, chapModel.chapterJSONModel.ext];
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
