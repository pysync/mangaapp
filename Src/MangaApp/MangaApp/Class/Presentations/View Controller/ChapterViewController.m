//
//  ChapterViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/19/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterViewController.h"

@interface ChapterViewController ()

@end

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self performSelector:@selector(hiddenBarViews) withObject:nil afterDelay:1];
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

- (void)createUI {
    self.title = @"Reading";
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBarViews:)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)hiddenBarViews {
    _headerView.hidden = YES;
    _bottomView.hidden = YES;
}

- (void)showBarViews:(UITapGestureRecognizer *)gesture {
    _headerView.hidden = NO;
    _bottomView.hidden = NO;
}

#pragma mark - Button Function
- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
