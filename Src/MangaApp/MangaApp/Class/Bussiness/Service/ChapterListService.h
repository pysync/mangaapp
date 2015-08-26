//
//  ChapterListService.h
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterJSONModel.h"

@interface ChapterListService : NSObject

@property (strong, nonatomic) NSMutableArray *listChapters;

- (void)getDataFromJSONSuccess:(void(^)())successBlock failure:(void(^)())failBlock;
- (void)createAndSaveDataIfNeed;
- (void)updateChapterWithIndexChap:(NSInteger )indexChap andState:(BOOL)isDownloaded;
- (void)removeChapterWithIndexChap:(NSInteger )indexChap finish:(void(^)())finishBlock;
@end
