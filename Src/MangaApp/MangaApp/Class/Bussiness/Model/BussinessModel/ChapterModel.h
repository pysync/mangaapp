//
//  ChapterModel.h
//  MangaApp
//
//  Created by ThanhLD on 5/7/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chapter.h"
#import "ChapterJSONModel.h"

@interface ChapterModel : NSObject

@property(nonatomic, strong) Chapter *chapterEntity;
@property(nonatomic, strong) ChapterJSONModel *chapterJSONModel;
@property(nonatomic, assign) BOOL isDownloading;
@property(nonatomic, assign) BOOL isFinishedDownload;
@end
