//
//  DownloadManager.h
//  MangaApp
//
//  Created by ThanhLD on 8/26/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterJSONModel.h"

@interface DownloadManager : NSObject

@property (nonatomic, copy) void(^finishLoadChapter)();
@property (nonatomic, copy) void(^failedLoadChapter)();

+ (id)sharedManager;
- (void)removeStatusChapter:(NSString *)chapterName;
- (void)readingChapterWithModel:(ChapterJSONModel *)chapterModel;
- (void)downloadChapterWithModel:(ChapterJSONModel *)chapterModel success:(void(^)())successBlock failure:(void(^)())failBlock;
@end
