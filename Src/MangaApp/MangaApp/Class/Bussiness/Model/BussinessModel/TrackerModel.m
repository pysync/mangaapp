//
//  TrackerModel.m
//  MangaApp
//
//  Created by ThanhLD on 9/16/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "TrackerModel.h"

@implementation TrackerModel

- (instancetype)initWithChapTracker:(ChapTracker *)tracker
{
    self = [super init];
    if (self) {
        _chapterID = tracker.chapterID;
        _pageName = tracker.pageName;
    }
    return self;
}

- (instancetype)initWithChapID:(NSNumber *)chapID
{
    self = [super init];
    if (self) {
        _chapterID = chapID;
        _pageName = @(1);
    }
    return self;
}
@end
