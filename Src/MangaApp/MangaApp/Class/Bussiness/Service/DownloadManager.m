//
//  DownloadManager.m
//  MangaApp
//
//  Created by ThanhLD on 8/26/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "DownloadManager.h"
#import "Definition.h"
#import "DownloadPhotoOperation.h"
#import "Common.h"

@interface DownloadManager()

@end

@implementation DownloadManager

+ (id)sharedManager {
    static DownloadManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadStatusInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)downloadChapterWithModel:(ChapterJSONModel *)chapterModel success:(void (^)())successBlock failure:(void (^)())failBlock {
    NSString *chapterName = [NSString stringWithFormat:@"%@%@", chapterModel.dirPrefix, chapterModel.chapterID];
    
    NSNumber *numberPhotos = _downloadStatusInfo[chapterName];
    if (!numberPhotos) {
        numberPhotos = @(0);
        [_downloadStatusInfo setObject:numberPhotos forKey:chapterName];
    }
    
    NSOperationQueue *photoQueue = [[NSOperationQueue alloc] init];
    NSString *baseURL = [kBaseUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", chapterModel.dirPrefix, chapterModel.chapterID]];
    for (int i=0; i<chapterModel.pageCount.integerValue; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%lu.%@", chapterModel.pagePrefix, (unsigned long)i + 1, chapterModel.ext];
        if (![self imageDownloadedWithImageName:imageName andChapterModel:chapterModel]) {
            NSString *fullURL = [baseURL stringByAppendingPathComponent:imageName];
            NSURL *URL = [NSURL URLWithString:fullURL];
            DownloadPhotoOperation *photoOperation = [[DownloadPhotoOperation alloc] initWithURL:URL];
            [photoQueue addOperation:photoOperation];
            
            photoOperation.didFinishDownload = ^(){
                NSNumber *numberPhotos = _downloadStatusInfo[chapterName];
                numberPhotos = @(numberPhotos.integerValue + 1);
                _downloadStatusInfo[chapterName] = numberPhotos;
                
                if (numberPhotos.integerValue == chapterModel.pageCount.integerValue) {
                    NSLog(@"All file download successfully");
                    if (successBlock) {
                        successBlock();
                    }
                }
            };
        }else {
            NSNumber *numberPhotos = _downloadStatusInfo[chapterName];
            numberPhotos = @(numberPhotos.integerValue + 1);
            _downloadStatusInfo[chapterName] = numberPhotos;
            
            if (numberPhotos.integerValue == chapterModel.pageCount.integerValue) {
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
@end
