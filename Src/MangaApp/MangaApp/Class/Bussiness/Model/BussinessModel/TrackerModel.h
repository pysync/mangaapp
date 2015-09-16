//
//  TrackerModel.h
//  MangaApp
//
//  Created by ThanhLD on 9/16/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapTracker.h"

@interface TrackerModel : NSObject

@property (nonatomic, strong) NSNumber *chapterID;
@property (nonatomic, strong) NSNumber *pageName;

- (instancetype)initWithChapTracker:(ChapTracker *)tracker;
- (instancetype)initWithChapID:(NSNumber *)chapID;
@end
