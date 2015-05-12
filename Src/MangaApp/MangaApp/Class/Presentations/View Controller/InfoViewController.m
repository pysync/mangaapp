//
//  InfoViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _closeButton.layer.cornerRadius = 4.0;
    _closeButton.layer.borderWidth = 1.0;
    _closeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    switch (subButton.tag) {
        case 1: {
            // About view controller
            subType = kAboutScreen;
            break;
        }
        case 2: {
            // Q & A view controller
            subType = kQAScreen;
            break;
        }
        case 3: {
            // Term vc
            subType = kTermScreen;
            break;
        }
        case 4: {
            // Contact vc
            subType = kContactScreen;
            break;
        }
        case 5: {
            // News vc
            subType = kNewsScreen;
            break;
        }
            
        default:
            break;
    }
    
    if (self.gotoSubInfoScreen) {
        self.gotoSubInfoScreen(subType);
    }
}

- (IBAction)onCloseButton:(id)sender {
    if (self.dismissInfoView) {
        self.dismissInfoView();
    }
}
@end
