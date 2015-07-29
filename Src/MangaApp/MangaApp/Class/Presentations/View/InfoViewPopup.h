//
//  InfoViewPopup.h
//  MangaApp
//
//  Created by ThanhLD on 7/28/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kAboutScreen = 1,
    kQAScreen,
    kTermScreen,
    kContactScreen,
    kNewsScreen,
    kNoneScreen
}SubInfoType;

@interface InfoViewPopup : UIView
@property (nonatomic, copy) void(^gotoSubInfoScreen)(SubInfoType subType, NSString *viewTitle);
@end
