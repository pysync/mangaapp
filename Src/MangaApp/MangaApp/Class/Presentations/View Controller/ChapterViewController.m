//
//  ChapterViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/19/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterViewController.h"
#import "PageViewController.h"

@interface ChapterViewController ()
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
    [self loadDataForScrollView];
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

- (void)loadDataForScrollView {
    NSUInteger numberPages = self.chapModel.images.count;
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.contentScollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.contentScollView.frame) * numberPages, CGRectGetHeight(self.contentScollView.frame));
    self.contentScollView.showsHorizontalScrollIndicator = NO;
    self.contentScollView.showsVerticalScrollIndicator = NO;
    self.contentScollView.scrollsToTop = NO;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
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

#pragma mark - 
- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= _chapModel.images.count)
        return;
    
    // replace the placeholder if necessary
    PageViewController *pageController = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)pageController == [NSNull null])
    {
        NSString *imageName = _chapModel.images[page];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        pageController = (PageViewController *)[story instantiateViewControllerWithIdentifier:@"PageViewController"];
        //pageController = [[PageViewController alloc] initWithImageName:imageName];
        [self.viewControllers replaceObjectAtIndex:page withObject:pageController];
    }
    
    // add the controller's view to the scroll view
    if (pageController.view.superview == nil)
    {
        CGRect frame = self.contentScollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page + 4;
        frame.origin.y = 0;
        frame.size.width -= 8;
        pageController.view.frame = frame;
        
        [self addChildViewController:pageController];
        [self.contentScollView addSubview:pageController.view];
        [pageController didMoveToParentViewController:self];
    }
}

#pragma mark - UIScrollView delegate
// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.contentScollView.frame);
    NSUInteger page = floor((self.contentScollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}
@end
