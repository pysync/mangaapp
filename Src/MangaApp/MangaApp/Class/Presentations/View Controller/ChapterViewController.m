//
//  ChapterViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/19/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterViewController.h"
#import "PageViewController.h"
#import "PhotoViewController.h"

@interface ChapterViewController ()<UIPageViewControllerDataSource>
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentPage = 0;
    _chapterService = [[ChapterService alloc] init];
    [self createUI];
    [self performSelector:@selector(hiddenBarViews) withObject:nil afterDelay:1];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self loadDataForScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    self.title = @"Reading";
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBarViews:)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    // Create Page view controller
    //PhotoViewController *pageZero = [PhotoViewController photoViewControllerForPageIndex:0];
    PhotoViewController *pageZero = [PhotoViewController photoViewControllerForPageIndex:0];
    if (pageZero != nil)
    {
        // assign the first page to the pageViewController (our rootViewController)
        UIPageViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewController"];
        pageViewController.dataSource = self;
        
        [pageViewController setViewControllers:@[pageZero]
                                     direction:UIPageViewControllerNavigationDirectionForward
                                      animated:NO
                                    completion:NULL];
        
        // Change the size of page view controller
        pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self addChildViewController:pageViewController];
        [self.view addSubview:pageViewController.view];
        [pageViewController didMoveToParentViewController:self];
    }
}

#pragma mark - PageViewController data sources
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    if (index) {
        return [PhotoViewController photoViewControllerForPageIndex:(index - 1)];
    }else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [PhotoViewController photoViewControllerForPageIndex:(index + 1)];
}

#pragma mark - Others
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
