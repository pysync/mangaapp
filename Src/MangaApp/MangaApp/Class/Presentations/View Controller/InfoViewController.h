//
//  InfoViewController.h
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kAboutScreen = 1,
    kQAScreen,
    kTermScreen,
    kContactScreen,
    kNoneScreen
}SubInfoType;

@interface InfoViewController : UIViewController

@property (nonatomic, copy) void(^gotoSubInfoScreen)(SubInfoType subType);

- (IBAction)onSubInfoButton:(id)sender;
@end
