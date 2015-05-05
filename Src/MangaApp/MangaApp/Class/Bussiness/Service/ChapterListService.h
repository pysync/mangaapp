//
//  ChapterListService.h
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterModel.h"

@interface ChapterListService : NSObject

@property (strong, nonatomic) NSMutableArray *listChapters;
@property (strong, nonatomic) NSMutableArray *listEntityChapters;

- (void)getDataFromJSONSuccess:(void(^)())successBlock failure:(void(^)())failBlock;
- (void)downloadChapterWithModel:(ChapterModel *)chapterModel success:(void(^)())successBlock failure:(void(^)())failBlock;
- (void)createAndSaveDataIfNeed;
- (void)updateChapterWithIndexChap:(NSInteger )indexChap andState:(BOOL)isDownloaded;
- (void)removeChapterWithIndexChap:(NSInteger )indexChap finish:(void(^)())finishBlock;
@end
