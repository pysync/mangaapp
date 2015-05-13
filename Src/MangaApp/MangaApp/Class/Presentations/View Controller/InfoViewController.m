//
//  InfoViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "InfoViewController.h"
#import "Definition.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _closeButton.layer.cornerRadius = 4.0;
    _closeButton.layer.borderWidth = 1.0;
    _closeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    // Do any additional setup after loading the view.
    
    [self localizableForViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)localizableForViews {
    [_aboutButton setTitle:NSLocalizedString(kAboutScreenLocalizable, nil) forState:UIControlStateNormal];
    [_qaButton setTitle:NSLocalizedString(kQAScreenLocalizable, nil) forState:UIControlStateNormal];
    [_termButton setTitle:NSLocalizedString(kTermScreenLocalizable, nil) forState:UIControlStateNormal];
    [_contactButton setTitle:NSLocalizedString(kContactScreenLocalizable, nil) forState:UIControlStateNormal];
    [_newsButton setTitle:NSLocalizedString(kNewsScreenLocalizable, nil) forState:UIControlStateNormal];
    [_closeButton setTitle:NSLocalizedString(kCloseButtonLocalizable, nil) forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Function
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

- (IBAction)onCloseButton:(id)sender {
    if (self.dismissInfoView) {
        self.dismissInfoView();
    }
}
@end
