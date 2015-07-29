//
//  InfoViewController.h
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewPopup.h"

@interface InfoViewController : UIViewController

@property (nonatomic, copy) void(^gotoSubInfoScreen)(SubInfoType subType, NSString *viewTitle);
@property (nonatomic, copy) void(^dismissInfoView)();
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *qaButton;
@property (weak, nonatomic) IBOutlet UIButton *termButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;

- (IBAction)onSubInfoButton:(id)sender;
- (IBAction)onCloseButton:(id)sender;
@end
