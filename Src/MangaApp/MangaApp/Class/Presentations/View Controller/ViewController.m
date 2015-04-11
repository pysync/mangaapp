//
//  ViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/11/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ViewController.h"
#import <WYPopoverController.h>
#import "InfoViewController.h"
#import "ChapterCustomCell.h"

@interface ViewController ()<WYPopoverControllerDelegate>
{
    WYPopoverController *infoPopoverController;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _chapterService = [[ChapterListService alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self createBarButton];
    [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChapterCustomCell class]) bundle:nil] forCellReuseIdentifier:[ChapterCustomCell getIdentifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Function
- (void)createBarButton {
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(onMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
}

#pragma mark - Buttons Function
- (void)onMenuButton:(id)sender {
    if (infoPopoverController == nil) {
        UIView* btn = (UIView*)sender;
        
        InfoViewController *infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
        
        if ([infoViewController respondsToSelector:@selector(setPreferredContentSize:)]) {
            infoViewController.preferredContentSize = CGSizeMake(280, 200);             // iOS 7
        }
        
        infoViewController.title = @"Info Screen";
        infoViewController.modalInPopover = NO;
        
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:infoViewController];
        
        infoPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        infoPopoverController.delegate = self;
        infoPopoverController.passthroughViews = @[btn];
        infoPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        infoPopoverController.wantsDefaultContentAppearance = NO;
        
        [infoPopoverController presentPopoverFromRect:btn.bounds
                                                   inView:btn
                                 permittedArrowDirections:WYPopoverArrowDirectionAny
                                                 animated:YES
                                                  options:WYPopoverAnimationOptionFadeWithScale];
    }
}

#pragma mark - WYPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == infoPopoverController)
    {
        infoPopoverController.delegate = nil;
        infoPopoverController = nil;
    }
}

#pragma mark - UITableView delegate and data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ChapterCustomCell getHeightOfCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChapterCustomCell *cell = (ChapterCustomCell *)[tableView dequeueReusableCellWithIdentifier:[ChapterCustomCell getIdentifier]];
    
    return cell;
}
@end
