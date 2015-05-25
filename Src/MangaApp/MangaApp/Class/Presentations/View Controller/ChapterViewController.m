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

@interface ChapterViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) BOOL isShowingBarView;
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
    [_chapterService getChapHistoryWithChapName:_chapModel.chapName];
    
    [self createUI];
    [self loadDataToView];
    //[self fetchAvailableProducts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStaminaView:) name:kUpdateStaminaView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBarViews:) name:kShowBarView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStaminaExpired:) name:kShowStaminaExpired object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self loadDataForScrollView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateStaminaView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowBarView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowStaminaExpired object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    _processSlider.minimumValue = 1.0;
    _processSlider.maximumValue = _chapModel.chapterJSONModel.images.count;
    
    _processView.layer.cornerRadius = 4.0;
    _processView.layer.borderWidth = 1.0;
    _processView.layer.borderColor = [UIColor blackColor].CGColor;
    _processView.layer.masksToBounds = YES;
    _processView.clipsToBounds = YES;
    
    // drop shadow
//    [_processView.layer setShadowColor:[UIColor orangeColor].CGColor];
//    [_processView.layer setShadowOpacity:1];
//    [_processView.layer setShadowRadius:3.0];
//    [_processView.layer setShadowOffset:CGSizeMake(-20.0, -20.0)];
    
    // Create Page view controller
    NSString *zeroImage = _chapModel.chapterJSONModel.images.firstObject;
    PhotoViewController *pageZero = [PhotoViewController photoViewControllerForPageIndex:0 imageName:zeroImage andService:_chapterService];
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
    
    _titleLabel.text = _chapModel.chapterJSONModel.titleChap;
    _pageLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)_chapModel.chapterJSONModel.images.count];
}

#pragma mark - PageViewController data sources
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    _currentPage = index;
    [self reloadBottomViewDataWithPageIndex:(index + 1)];
    if (index) {
        return [PhotoViewController photoViewControllerForPageIndex:(index - 1) imageName:_chapModel.chapterJSONModel.images[index - 1] andService:_chapterService];
    }else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    _currentPage = index;
    [self reloadBottomViewDataWithPageIndex:(index + 1)];
    if (index < _chapModel.chapterJSONModel.images.count - 1) {
        return [PhotoViewController photoViewControllerForPageIndex:(index + 1) imageName:_chapModel.chapterJSONModel.images[index + 1] andService:_chapterService];
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
        [_processSlider setValue:pageIndex animated:NO];
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)pageIndex, (unsigned long)_chapModel.chapterJSONModel.images.count];
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
    StaminaConfig *staminaConfig = [StaminaConfig sharedConfig];
    NSString *currentImageName = _chapModel.chapterJSONModel.images[_currentPage];
    
    if (![staminaConfig.chapTrackList containsObject:currentImageName]) {
        if (staminaConfig.stamina >= _chapterService.chapterModel.staminaCost) {
            staminaConfig.stamina -= _chapterService.chapterModel.staminaCost;
            [staminaConfig.chapTrackList addObject:currentImageName];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateStaminaView object:nil];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowStaminaExpired object:nil];
        }
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
    NSUInteger index = (NSUInteger)(_processSlider.value + 0.5);
    
    if (index > _currentPage + 1) {
        PhotoViewController *nextPage = [PhotoViewController photoViewControllerForPageIndex:(index - 1) imageName:_chapModel.chapterJSONModel.images[index - 1] andService:_chapterService];;
        [_pageViewController setViewControllers:@[nextPage]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    }else if (index < _currentPage + 1) {
        PhotoViewController *previousPage = [PhotoViewController photoViewControllerForPageIndex:(index - 1) imageName:_chapModel.chapterJSONModel.images[index - 1] andService:_chapterService];;
        [_pageViewController setViewControllers:@[previousPage]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:nil];
    }
    _currentPage = index - 1;
    [self reloadBottomViewDataWithPageIndex:index];
}

- (IBAction)onBackButton:(id)sender {
    [[StaminaConfig sharedConfig] saveData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
