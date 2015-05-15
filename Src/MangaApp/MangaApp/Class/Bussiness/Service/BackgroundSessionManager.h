//
//  BackgroundSessionManager.h
//  MangaApp
//
//  Created by ThanhLD on 5/15/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BackgroundSessionManager : AFHTTPSessionManager
+ (instancetype)sharedManager;

@property (nonatomic, copy) void (^savedCompletionHandler)(void);
@end
