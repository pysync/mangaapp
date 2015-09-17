//
//  StaminaConfig.h
//  MangaApp
//
//  Created by ThanhLD on 5/8/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackerModel.h"

@interface StaminaConfig : NSObject

@property (nonatomic, assign) NSInteger stamina;
@property (nonatomic, assign) float maxStamina;
@property (nonatomic, strong) TrackerModel *tracker;

+ (id)sharedConfig;
- (void)saveData;
- (void)reStoreStaminaConfig;
@end
