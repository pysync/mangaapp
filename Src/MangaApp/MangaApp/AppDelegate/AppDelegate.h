//
//  AppDelegate.h
//  MangaApp
//
//  Created by ThanhLD on 4/11/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();

@end

