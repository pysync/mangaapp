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
#import "SubInfoViewController.h"
#import "ChapterViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()<WYPopoverControllerDelegate>
{
    
}
@property (nonatomic, strong) WYPopoverController *infoPopoverController;
@property (nonatomic, strong) InfoViewController *infoViewController ;
@end
 
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _chapterService = [[ChapterListService alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self createBarButton];
    [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChapterCustomCell class]) bundle:nil] forCellReuseIdentifier:[ChapterCustomCell getIdentifier]];
    
    // Test Parse.com
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController.navigationBarHidden) {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    }
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
    if (_infoPopoverController == nil) {
        UIView* btn = (UIView*)sender;
        
        _infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
        
        if ([_infoViewController respondsToSelector:@selector(setPreferredContentSize:)]) {
            _infoViewController.preferredContentSize = CGSizeMake(280, 200);             // iOS 7
        }
        
        _infoViewController.title = @"Info Screen";
        _infoViewController.modalInPopover = NO;
        
        // Call back function
        __weak typeof(self) weakSelf = self;
        _infoViewController.gotoSubInfoScreen = ^(SubInfoType subType){
            [weakSelf.infoPopoverController dismissPopoverAnimated:YES completion:^{
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SubInfoViewController *subInfoVC = (SubInfoViewController *)[story instantiateViewControllerWithIdentifier:NSStringFromClass([SubInfoViewController class])];
                subInfoVC.title = @"Sub Info View";
                subInfoVC.didClickCloseButton = ^() {
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                };
                
                UINavigationController *subNavi = [[UINavigationController alloc] initWithRootViewController:subInfoVC];
                [weakSelf presentViewController:subNavi animated:YES completion:^{
                    
                }];
                
                [weakSelf releasePopoverController];
            }];
        };
        
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:_infoViewController];
        
        _infoPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        _infoPopoverController.delegate = self;
        _infoPopoverController.passthroughViews = @[btn];
        _infoPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        _infoPopoverController.wantsDefaultContentAppearance = NO;
        
        [_infoPopoverController presentPopoverFromRect:btn.bounds
                                                   inView:btn
                                 permittedArrowDirections:WYPopoverArrowDirectionAny
                                                 animated:YES
                                                  options:WYPopoverAnimationOptionFadeWithScale];
    }
}

- (void)goToReadingScreenWithIndexChapter:(NSInteger )indexChap {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChapterViewController *chapterVC = (ChapterViewController *)[story instantiateViewControllerWithIdentifier:NSStringFromClass([ChapterViewController class])];
    [self.navigationController pushViewController:chapterVC animated:YES];
}

#pragma mark - Service Function
- (void)loadDataFromJSON {
    NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"define" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:pathFile encoding:NSUTF8StringEncoding error:nil];
    
}

#pragma mark - WYPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller {
    if (controller == _infoPopoverController) {
        [self releasePopoverController];
    }
}

- (void)releasePopoverController {
    _infoPopoverController.delegate = nil;
    _infoPopoverController = nil;
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
    
    cell.onStartReadingButton = ^(){
        [self goToReadingScreenWithIndexChapter:(indexPath.row + 1)];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
@end
