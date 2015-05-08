//
//  StaminaConfig.h
//  MangaApp
//
//  Created by ThanhLD on 5/8/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaminaConfig : NSObject

@property (nonatomic, assign) NSInteger stamina;
@property (nonatomic, assign) float maxStamina;
@property (nonatomic, strong) NSMutableArray *chapTrackList;
@property (nonatomic, strong) NSString *chapName;

+ (id)sharedConfig;
- (void)saveData;
@end
