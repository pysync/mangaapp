//
//  StaminaConfig.m
//  MangaApp
//
//  Created by ThanhLD on 5/8/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "StaminaConfig.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ChapTracker.h"
#import "Definition.h"

@implementation StaminaConfig

+ (id)sharedConfig {
    static StaminaConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxStamina = [self getMaxStaminaConfig];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSInteger savedStamina = [userDefault integerForKey:kStaminaSaved];
        
        if (!savedStamina) {
            savedStamina = _maxStamina;
        }
        
        _stamina = savedStamina;
    }
    return self;
}

- (float )getMaxStaminaConfig {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"staminaConfig" ofType:@"plist"];
    NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *staminaString = configDic[@"stamina"];
    return staminaString.floatValue;
}

- (void)saveData {
    UIApplication *application = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        ChapTracker *trackerEntity = [ChapTracker MR_findFirstByAttribute:@"chapterID" withValue:_tracker.chapterID inContext:localContext];
        if (trackerEntity) {
            trackerEntity.pageName = _tracker.pageName;
        }else {
            trackerEntity = [ChapTracker MR_createEntityInContext:localContext];
            trackerEntity.chapterID = _tracker.chapterID;
            trackerEntity.pageName = _tracker.pageName;
        }
    } completion:^(BOOL success, NSError *error) {
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:_stamina forKey:kStaminaSaved];
    [userDefault synchronize];
}

- (void)reStoreStaminaConfig {
    _stamina = [self getMaxStaminaConfig];
}
@end
