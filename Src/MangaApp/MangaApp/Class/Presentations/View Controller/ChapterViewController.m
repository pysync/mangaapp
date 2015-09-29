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
#import "Definition.h"
#import "StaminaConfig.h"
#import <StoreKit/StoreKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DownloadManager.h"

@interface ChapterViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) BOOL isShowingBarView;
@property (nonatomic, strong) PhotoViewController *endPageVC;
@property (nonatomic, strong) PhotoViewController *currentPageVC;
@end

#define kTagShowStamina 100
#define kProductIdentifier @"com.thanhld.MangaApp02"

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentPage = 0;
    _isShowingBarView = YES;
    
    _chapterService = [[ChapterService alloc] initWithModel:_chapModel];
    [_chapterService getChapHistoryWithChapName:_chapModel.chapterEntity.chapterID];
    
    [self createUI];
    [self loadDataToView];
    [self performSelector:@selector(startDownloadingManga) withObject:nil afterDelay:0.3];
    //[self startDownloadingManga];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStaminaView:) name:kUpdateStaminaView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBarViews:) name:kShowBarView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStaminaExpired:) name:kShowStaminaExpired object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePageVCIfNeed:) name:kFinishDownloadAnImage object:nil];
    
    [self performSelector:@selector(showFullAds:) withObject:nil afterDelay:3];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)showFullAds:(id)sender {
    if ([self.interstitial isReady] && [self isKindOfClass:[ChapterViewController class]]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateStaminaView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowBarView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowStaminaExpired object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFinishDownloadAnImage object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    _processSlider.minimumValue = 1.0;
    _processSlider.maximumValue = _chapModel.chapterEntity.pageCount.integerValue;
    _processSlider.minimumTrackTintColor = [UIColor whiteColor];
    _processSlider.maximumTrackTintColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:1.0 alpha:1.0];
    
    _processView.layer.cornerRadius = 12.0;
    _processView.layer.borderWidth = 3.0;
    _processView.layer.borderColor = [UIColor whiteColor].CGColor;
    _processView.layer.masksToBounds = YES;
    _processView.clipsToBounds = YES;
    
    // Create Page view controller
    StaminaConfig *config = [StaminaConfig sharedConfig];
    _currentPage = config.tracker.pageName.integerValue;
    [self reloadBottomViewDataWithPageIndex:_currentPage];
    
    NSString *zeroImage = [NSString stringWithFormat:@"%@%ld.%@", _chapModel.chapterEntity.pagePrefix, (long)config.tracker.pageName.integerValue, _chapModel.chapterEntity.ext];
    PhotoViewController *pageZero = [PhotoViewController photoViewControllerForPageIndex:config.tracker.pageName.integerValue imageName:zeroImage andService:_chapterService];
    self.currentPageVC = pageZero;
    if (pageZero != nil)
    {
        // assign the first page to the pageViewController (our rootViewController)
        _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewController"];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        [_pageViewController setViewControllers:@[pageZero]
                                     direction:UIPageViewControllerNavigationDirectionForward
                                      animated:NO
                                    completion:NULL];
        
        // Change the size of page view controller
        _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [_pageViewController didMoveToParentViewController:self];
        
        [self.view bringSubviewToFront:_headerView];
        [self.view bringSubviewToFront:_bottomView];
    }
}

- (void)loadDataToView {
    StaminaConfig *config = [StaminaConfig sharedConfig];
    _processView.progress = config.stamina/config.maxStamina;
    _staminaLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)config.stamina,(int)config.maxStamina];
    _titleLabel.text = _chapModel.chapterEntity.chapterName;
}

#pragma mark - Download Photos
- (void)startDownloadingManga {
    if (!_chapModel.isFinishedDownload && !_chapModel.isDownloading) {
        _chapModel.isDownloading = YES;
        DownloadManager *downloadManager = [DownloadManager sharedManager];
        [downloadManager readingChapterWithModel:_chapModel.chapterJSONModel];
    }
}

#pragma mark - PageViewController data sources
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSInteger index = vc.pageIndex;
    _currentPage = index;
    self.currentPageVC = vc;
    [self reloadBottomViewDataWithPageIndex:index];
    if (index < _chapModel.chapterEntity.pageCount.integerValue && [vc imageDownloaded]) {
        NSString *imageName = [NSString stringWithFormat:@"%@%ld.%@", _chapModel.chapterEntity.pagePrefix, (long)(index + 1), _chapModel.chapterEntity.ext];
        
        return [PhotoViewController photoViewControllerForPageIndex:(index + 1) imageName:imageName andService:_chapterService];
    }
    self.endPageVC = vc;
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{
    NSInteger index = vc.pageIndex;
    _currentPage = index;
    self.currentPageVC = vc;
    [self reloadBottomViewDataWithPageIndex:index];
    if (index > 1) {
        NSString *imageName = [NSString stringWithFormat:@"%@%ld.%@", _chapModel.chapterEntity.pagePrefix, (long)(index - 1), _chapModel.chapterEntity.ext];
        
        return [PhotoViewController photoViewControllerForPageIndex:(index - 1) imageName:imageName andService:_chapterService];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    if (_isShowingBarView) {
        [self hiddenBarViews];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}

#pragma mark -
- (void)fixAndResetEndPage {
    if (self.endPageVC && self.endPageVC == self.currentPageVC) {
        [self.pageViewController setViewControllers:@[self.currentPageVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.endPageVC = nil;
    }
}

#pragma mark - Others
- (void)hiddenBarViews {
    _isShowingBarView = NO;
    _headerView.hidden = YES;
    _bottomView.hidden = YES;
}

- (void)showBarViews {
    _isShowingBarView = YES;
    _headerView.hidden = NO;
    _bottomView.hidden = NO;
}

- (void)showBarViews:(NSNotification *)notification {
    if (_isShowingBarView) {
        [self hiddenBarViews];
    }else {
        [self showBarViews];
    }
}

- (void)reloadBottomViewDataWithPageIndex:(NSInteger )pageIndex {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger currentValue = _chapModel.chapterEntity.pageCount.integerValue - pageIndex + 1;
        [_processSlider setValue:currentValue animated:NO];
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)pageIndex, (unsigned long)_chapModel.chapterEntity.pageCount.integerValue];
    });
}

- (void)showStaminaExpired:(NSNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"体力がなくなりました"
                                                   delegate:self
                                          cancelButtonTitle:@"戻る"
                                          otherButtonTitles:@"全回復する", nil];
    alert.tag = kTagShowStamina;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

- (void)updateStaminaView:(NSNotification *)notification {
    StaminaConfig *config = [StaminaConfig sharedConfig];
    dispatch_async(dispatch_get_main_queue(), ^{
        _processView.progress = config.stamina/config.maxStamina;
        _staminaLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)config.stamina,(int)config.maxStamina];
    });
}

- (void)updateStaminaConfig {
    if (_chapterService.chapterModel.chapterEntity.freeFlg.integerValue == 0) {
        StaminaConfig *staminaConfig = [StaminaConfig sharedConfig];
        if (staminaConfig.tracker.pageName.integerValue < _currentPage) {
            if (staminaConfig.stamina >= _chapterService.chapterModel.chapterEntity.cost.integerValue) {
                staminaConfig.stamina -= _chapterService.chapterModel.chapterEntity.cost.integerValue;
                staminaConfig.tracker.pageName = @(_currentPage);
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateStaminaView object:nil];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowStaminaExpired object:nil];
            }
        }
    }
}

- (void)updatePageVCIfNeed:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.userInfo;
    NSString *imageName = userInfoDic[kImageNameNotification];
    if ([imageName isEqualToString:self.currentPageVC.imageName]) {
        [self fixAndResetEndPage];
    }
}

#pragma mark - UIAlert View delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kTagShowStamina) {
        if (buttonIndex == 1) {
            // Buy stamina on app store
            MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
            hub.labelText = @"Purchasing...";
            [self.view addSubview:hub];
            [hub show:YES];
            
            [self fetchAvailableProducts];
        }else {
            // Back to Chapter List Screen
            [self onBackButton:nil];
        }
    }
}

#pragma mark - StoreKit Delegate
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:kProductIdentifier]) {
                    NSLog(@"Purchase is completed succesfully ");
                    StaminaConfig *config = [StaminaConfig sharedConfig];
                    [config reStoreStaminaConfig];
                    
                    [self updateStaminaConfig];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                break;
            default:
                break;
        }
    }
}

#pragma mark - In-App Purchase
-(void)fetchAvailableProducts{
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        NSSet *productIdentifiers = [NSSet
                                     setWithObjects:kProductIdentifier,nil];
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchaseMyProduct:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchaseMyProduct:(SKProduct*)product{
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark - Button Function
- (IBAction)changePage:(id)sender {
    NSInteger index = _chapModel.chapterEntity.pageCount.integerValue - (NSInteger)_processSlider.value + 1;
    
    
    NSString *imageName = [NSString stringWithFormat:@"%@%ld.%@", _chapModel.chapterEntity.pagePrefix, (long)index, _chapModel.chapterEntity.ext];
    
    NSMutableArray *viewcontrollers = [[NSMutableArray alloc] initWithCapacity:0];
    PhotoViewController *currentPage = [PhotoViewController photoViewControllerForPageIndex:index imageName:imageName andService:_chapterService];
    [viewcontrollers addObject:currentPage];
    
    if (index > _currentPage) {
        __weak ChapterViewController *blocksafeSelf = self;
        [self.pageViewController setViewControllers:viewcontrollers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished){
            if(finished)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [blocksafeSelf.pageViewController setViewControllers:viewcontrollers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:NULL];// bug fix for uipageview controller
                    PhotoViewController *pageVC = (PhotoViewController *)viewcontrollers.firstObject;
                    _currentPage = pageVC.pageIndex;
                    [blocksafeSelf reloadBottomViewDataWithPageIndex:index];
                });
            }
        }];
    }else if (index < _currentPage) {
        __weak ChapterViewController *blocksafeSelf = self;
        [self.pageViewController setViewControllers:viewcontrollers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){
            if(finished)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [blocksafeSelf.pageViewController setViewControllers:viewcontrollers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
                    PhotoViewController *pageVC = (PhotoViewController *)viewcontrollers.firstObject;
                    _currentPage = pageVC.pageIndex;
                    [blocksafeSelf reloadBottomViewDataWithPageIndex:index];
                });
            }
        }];
    }
}

- (IBAction)onBackButton:(id)sender {
    [[StaminaConfig sharedConfig] saveData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
