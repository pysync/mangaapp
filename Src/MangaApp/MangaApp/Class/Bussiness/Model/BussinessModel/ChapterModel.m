//
//  ChapterModel.m
//  MangaApp
//
//  Created by ThanhLD on 5/7/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterModel.h"

@implementation ChapterModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isDownloading = NO;
        _isFinishedDownload = NO;
    }
    return self;
}
@end
