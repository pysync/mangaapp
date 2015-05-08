//
//  StaminaConfig.m
//  MangaApp
//
//  Created by ThanhLD on 5/8/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "StaminaConfig.h"

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
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"staminaConfig" ofType:@"plist"];
        NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *staminaString = configDic[@"stamina"];
        _stamina = staminaString.integerValue;
    }
    return self;
}
@end
