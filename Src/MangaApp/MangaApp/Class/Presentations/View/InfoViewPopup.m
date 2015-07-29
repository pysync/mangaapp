//
//  InfoViewPopup.m
//  MangaApp
//
//  Created by ThanhLD on 7/28/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "InfoViewPopup.h"
#import "Definition.h"

@interface InfoViewPopup()
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *qaButton;
@property (weak, nonatomic) IBOutlet UIButton *termButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

- (IBAction)onSubInfoButton:(id)sender;
@end

@implementation InfoViewPopup

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleButton setTitle:NSLocalizedString(kInfoScreenLocalizable, nil) forState:UIControlStateNormal];
    [_aboutButton setTitle:NSLocalizedString(kAboutScreenLocalizable, nil) forState:UIControlStateNormal];
    [_qaButton setTitle:NSLocalizedString(kQAScreenLocalizable, nil) forState:UIControlStateNormal];
    [_termButton setTitle:NSLocalizedString(kTermScreenLocalizable, nil) forState:UIControlStateNormal];
    [_contactButton setTitle:NSLocalizedString(kContactScreenLocalizable, nil) forState:UIControlStateNormal];
}

- (IBAction)onSubInfoButton:(id)sender {
    UIButton *subButton = (UIButton *)sender;
    SubInfoType subType = kNoneScreen;
    NSString *titleView = @"";
    switch (subButton.tag) {
        case 1: {
            // About view controller
            subType = kAboutScreen;
            titleView = NSLocalizedString(kAboutScreenLocalizable, nil);
            break;
        }
        case 2: {
            // Q & A view controller
            subType = kQAScreen;
            titleView = NSLocalizedString(kQAScreenLocalizable, nil);
            break;
        }
        case 3: {
            // Term vc
            subType = kTermScreen;
            titleView = NSLocalizedString(kTermScreenLocalizable, nil);
            break;
        }
        case 4: {
            // Contact vc
            subType = kContactScreen;
            titleView = NSLocalizedString(kContactScreenLocalizable, nil);
            break;
        }
        case 5: {
            // News vc
            subType = kNewsScreen;
            titleView = NSLocalizedString(kNewsScreenLocalizable, nil);
            break;
        }
            
        default:
            break;
    }
    
    if (self.gotoSubInfoScreen) {
        self.gotoSubInfoScreen(subType, titleView);
    }
}
@end
