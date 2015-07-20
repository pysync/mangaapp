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
#import <MBProgressHUD/MBProgressHUD.h>
#import "Chapter.h"
#import "Definition.h"
#import <AFNetworking/AFNetworking.h>
#import <KLCPopup/KLCPopup.h>
#import "NewsViewPopup.h"
#import "StaminaConfig.h"

@interface ViewController ()<WYPopoverControllerDelegate>
{
    
}
@property (nonatomic, strong) WYPopoverController *infoPopoverController;
@property (nonatomic, strong) InfoViewController *infoViewController;
@property (nonatomic, assign) NSInteger indexRemoveChapter;
@end

#define kTagRemoveChapter 100


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createUI];
    
    _chapterService = [[ChapterListService alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChapterCustomCell class]) bundle:nil] forCellReuseIdentifier:[ChapterCustomCell getIdentifierCell]];
    
    // Test Parse.com
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];

    // Load data from json
    [self loadDataFromJSON];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self loadNewsScreenIfNeed];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                
                break;
        }
    }];
    
    // Ads
    self.bannerView.adUnitID = kBannerAdsID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.navigationController.navigationBarHidden) {
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
    }
    [self updateProcessBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewsScreenIfNeed {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastDateString = [userDefault stringForKey:kLastShowNews];
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"yyyy-MM-ddHH:mm:ss ZZZ"];
    
    if (lastDateString) {
        NSDate *lastDate = [dateF dateFromString:lastDateString];
        NSDate *currentDate = [NSDate date];
        
        NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:lastDate];
        int numberOfDays = secondsBetween / 86400;
        
        if (numberOfDays > 1) {
            NSString *currentDateString = [dateF stringFromDate:currentDate];
            [userDefault setObject:currentDateString forKey:kLastShowNews];
            [userDefault synchronize];
            
            [self loadNewsScreen];
        }
    }else {
        NSString *currentDateString = [dateF stringFromDate:[NSDate date]];
        [userDefault setObject:currentDateString forKey:kLastShowNews];
        [userDefault synchronize];
        
        [self loadNewsScreen];
    }
}

- (void)loadNewsScreen {
    NewsViewPopup *newsView = (NewsViewPopup *)[[[NSBundle mainBundle] loadNibNamed:@"NewsViewPopup" owner:self options:nil] objectAtIndex:0];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:newsView
                                            showType:KLCPopupShowTypeFadeIn
                                         dismissType:KLCPopupDismissTypeFadeOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    popup.didFinishShowingCompletion = ^() {
        [newsView loadWebView];
    };
    
    newsView.didCloseNewsCompletion = ^(){
        [popup dismissPresentingPopup];
    };
    
    [popup show];
}

- (void)createUI {
    _processView.layer.cornerRadius = 12.0;
    _processView.layer.borderWidth = 3.0;
    _processView.layer.borderColor = [UIColor whiteColor].CGColor;
    _processView.layer.masksToBounds = YES;
    _processView.clipsToBounds = YES;
}

#pragma mark - UI Function
- (void)updateProcessBar {
    StaminaConfig *config = [StaminaConfig sharedConfig];
    _processView.progress = config.stamina/config.maxStamina;
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)config.stamina,(int)config.maxStamina];
}

#pragma mark - Buttons Function
- (IBAction)onMenuButton:(id)sender {
    if (_infoPopoverController == nil) {
        UIView* btn = (UIView*)sender;
        
        _infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
        
        if ([_infoViewController respondsToSelector:@selector(setPreferredContentSize:)]) {
            _infoViewController.preferredContentSize = CGSizeMake(280, 320);             // iOS 7
        }
        
        _infoViewController.title = NSLocalizedString(kInfoScreenLocalizable, nil);
        _infoViewController.modalInPopover = NO;
        
        // Call back function
        __weak typeof(self) weakSelf = self;
        _infoViewController.gotoSubInfoScreen = ^(SubInfoType subType, NSString *viewTitle){
            [weakSelf.infoPopoverController dismissPopoverAnimated:YES completion:^{
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SubInfoViewController *subInfoVC = (SubInfoViewController *)[story instantiateViewControllerWithIdentifier:NSStringFromClass([SubInfoViewController class])];
                subInfoVC.title = viewTitle;
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
        
        _infoViewController.dismissInfoView = ^(){
            [weakSelf.infoPopoverController dismissPopoverAnimated:YES completion:^{
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

- (void)downloadMangaWithIndexChapter:(NSInteger )indexChap {
    ChapterCustomCell *cell = (ChapterCustomCell *)[_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexChap inSection:0]];
    cell.downloadState = kDownloadingState;
    
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.labelText = @"Downloading...";
    [self.view addSubview:hub];
    [hub show:YES];
    
    ChapterModel *chapModel = _chapterService.listChapters[indexChap];
    chapModel.isDownloading = YES;
    [_chapterService downloadChapterWithModel:chapModel.chapterJSONModel success:^{
        cell.downloadState = kDownloadedState;
        chapModel.isFinishedDownload = YES;
        chapModel.isDownloading = NO;
        [_chapterService updateChapterWithIndexChap:indexChap andState:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)removeChapWithIndexChapter:(NSInteger )indexChap {
    _indexRemoveChapter = indexChap;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedString(kRemoveMessageLocalizable, nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(kCancelTitleLocalizable, nil)
                                          otherButtonTitles:NSLocalizedString(kOKTitleLocalizable, nil), nil];
    alert.tag = kTagRemoveChapter;
    [alert show];
}

- (void)readingChapWithIndexChapter:(NSInteger )indexChap {
    ChapterModel *chapModel = (ChapterModel *)_chapterService.listChapters[indexChap];
    if (!chapModel.isFinishedDownload) {
        chapModel.isDownloading = YES;
        [_chapterService downloadChapterWithModel:chapModel.chapterJSONModel success:^{
            chapModel.isFinishedDownload = YES;
            chapModel.isDownloading = NO;
            [_chapterService updateChapterWithIndexChap:indexChap andState:YES];
            
            UIViewController *topVC = self.navigationController.topViewController;
            if ([topVC isKindOfClass:[self class]]) {
                [_contentTableView reloadData];
            }
        } failure:^{
            chapModel.isDownloading = NO;
            chapModel.isFinishedDownload = NO;
            UIViewController *topVC = self.navigationController.topViewController;
            if ([topVC isKindOfClass:[self class]]) {
                [_contentTableView reloadData];
            }
        }];
    }
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChapterViewController *chapterVC = (ChapterViewController *)[story instantiateViewControllerWithIdentifier:NSStringFromClass([ChapterViewController class])];
    
    chapterVC.chapModel = chapModel;
    chapterVC.chapterListService = _chapterService;
    [self.navigationController pushViewController:chapterVC animated:YES];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kTagRemoveChapter) {
        if (buttonIndex == 1) {
            MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
            hub.labelText = @"Removing...";
            [self.view addSubview:hub];
            [hub show:YES];
            
            ChapterModel *chapModel = _chapterService.listChapters[_indexRemoveChapter];
            [_chapterService removeChapterWithIndexChap:_indexRemoveChapter finish:^{
                ChapterCustomCell *cell = (ChapterCustomCell *)[_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_indexRemoveChapter inSection:0]];
                cell.downloadState = kBeforeDownloadState;
                chapModel.isFinishedDownload = NO;
                chapModel.isDownloading = NO;
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }
    }
}

#pragma mark - Service Function
- (void)loadDataFromJSON {
    [_chapterService getDataFromJSONSuccess:^{
        [_contentTableView reloadData];
    } failure:^{
        [_contentTableView reloadData];
    }];
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
    return _chapterService.listChapters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ChapterCustomCell getHeightCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChapterCustomCell *cell = (ChapterCustomCell *)[tableView dequeueReusableCellWithIdentifier:[ChapterCustomCell getIdentifierCell]];
    
    cell.onStartDownloadButton = ^(){
        [self downloadMangaWithIndexChapter:indexPath.row];
    };
    cell.onStartRemoveButton = ^(){
        [self removeChapWithIndexChapter:indexPath.row];
    };
    cell.onStartReadingButton = ^(){
        [self readingChapWithIndexChapter:indexPath.row];
    };
    
    ChapterModel *chapModel = _chapterService.listChapters[indexPath.row];
    if (chapModel.isFinishedDownload) {
        cell.downloadState = kDownloadedState;
    }else if (chapModel.isDownloading) {
        cell.downloadState = kDownloadingState;
    }else {
        cell.downloadState = chapModel.chapterEntity.isDownloaded.integerValue == 1 ? kDownloadedState:kBeforeDownloadState;
    }
    
    [cell updateCellWithModel:chapModel.chapterJSONModel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self readingChapWithIndexChapter:indexPath.row];
}

@end
