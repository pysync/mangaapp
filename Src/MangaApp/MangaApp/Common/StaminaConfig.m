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
    NSArray *trackerList = [ChapTracker MR_findByAttribute:@"chapterID" withValue:_chapterID];
    NSMutableArray *chapList = [[NSMutableArray alloc] initWithCapacity:0];
    for (ChapTracker *tracker in trackerList) {
        [chapList addObject:tracker.chapterID];
    }
    
    if (chapList.count != _chapTrackList.count) {
        for (int i=0; i<_chapTrackList.count; i++) {
            if (![chapList containsObject:_chapTrackList[i]]) {
                // Create new entity
                [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                    ChapTracker *newTrack = [ChapTracker MR_createEntityInContext:localContext];
                    newTrack.chapterID = _chapterID;
                    newTrack.pageName = _chapTrackList[i];
                }];
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
