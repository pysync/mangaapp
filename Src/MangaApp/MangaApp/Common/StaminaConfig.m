//
//  StaminaConfig.m
//  MangaApp
//
//  Created by ThanhLD on 5/8/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "StaminaConfig.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
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
        _chapTrackList = [[NSMutableArray alloc] initWithCapacity:0];
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
    NSArray *trackerList = [ChapTracker MR_findByAttribute:@"chapName" withValue:_chapName];
    NSMutableArray *chapList = [[NSMutableArray alloc] initWithCapacity:0];
    for (ChapTracker *tracker in trackerList) {
        [chapList addObject:tracker.chapName];
    }
    
    if (chapList.count != _chapTrackList.count) {
        for (int i=0; i<_chapTrackList.count; i++) {
            if (![chapList containsObject:_chapTrackList[i]]) {
                // Create new entity
                ChapTracker *newTrack = [ChapTracker MR_createEntity];
                newTrack.chapName = _chapName;
                newTrack.pageName = _chapTrackList[i];
                [newTrack.managedObjectContext MR_saveToPersistentStoreAndWait];
            }
        }
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:_stamina forKey:kStaminaSaved];
    [userDefault synchronize];
}

- (void)reStoreStaminaConfig {
    _stamina = [self getMaxStaminaConfig];
}
@end
