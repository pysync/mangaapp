/*
     File: PhotoViewController.m
 Abstract: Configures and displays the paging scroll view and handles tiling and page configuration.
  Version: 1.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "PhotoViewController.h"
#import "ImageScrollView.h"
#import "Definition.h"
#import "Common.h"
#import "ChapterService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "StaminaConfig.h"

@interface PhotoViewController ()
{
    
}

@property (nonatomic, strong)ImageScrollView *scrollView;
@property (nonatomic, strong)ChapterService *photoService;
@property (nonatomic, assign) BOOL imageLoaded;
@end

@implementation PhotoViewController

+ (PhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex imageName:(NSString *)imageName andService:(ChapterService *)chapterService {
    return [[self alloc] initWithPageIndex:pageIndex imageName:imageName andService:chapterService];
}

- (id)initWithPageIndex:(NSInteger)pageIndex imageName:(NSString *)imageName andService:(ChapterService *)chapterService {
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _pageIndex = pageIndex;
        _imageName = imageName;
        _imageLoaded = NO;
        _photoService = chapterService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBarViews:)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhotoIfNeed:) name:kFinishDownloadAnImage object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!_imageLoaded) {
        MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
        hub.color = [UIColor clearColor];
        [self.view addSubview:hub];
        [hub show:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    StaminaConfig *staminaConfig = [StaminaConfig sharedConfig];
    if (![staminaConfig.chapTrackList containsObject:_imageName]) {
        if (staminaConfig.stamina >= _photoService.chapterModel.chapterEntity.cost.integerValue) {
            staminaConfig.stamina -= _photoService.chapterModel.chapterEntity.cost.integerValue;
            [staminaConfig.chapTrackList addObject:_imageName];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateStaminaView object:nil];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowStaminaExpired object:nil];
        }
    }
}

- (void)loadView
{
    _scrollView = [[ImageScrollView alloc] init];
    _scrollView.index = _pageIndex;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = _scrollView;
    _scrollView.displayImage = [self imageWillDisplay];
}

- (UIImage *)imageWillDisplay {
    UIImage *displayImage = [UIImage imageNamed:@"placeholder"];
    NSString *docsPath = [Common getDocumentDirectory];
    NSString *localImagePath = [docsPath stringByAppendingPathComponent:_imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localImagePath]) {
        _imageLoaded = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        displayImage = [UIImage imageWithContentsOfFile:localImagePath];
    }
//    else {
//        [self downloadImageFromServer];
//    }
    
    return displayImage;
}

#pragma mark - Notification Function 
- (void)updatePhotoIfNeed:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.userInfo;
    NSString *imageName = userInfoDic[kImageNameNotification];
    if ([imageName isEqualToString:_imageName]) {
        _imageLoaded = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIImage *displayImage = [UIImage imageNamed:@"placeholder"];
        NSString *docsPath = [Common getDocumentDirectory];
        NSString *localImagePath = [docsPath stringByAppendingPathComponent:_imageName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localImagePath]) {
            displayImage = [UIImage imageWithContentsOfFile:localImagePath];
        }
        _scrollView.displayImage = displayImage;
    }
}

#pragma mark - Service Function
- (void)downloadImageFromServer {
    [_photoService downloadImageWithName:_imageName success:^{
        _imageLoaded = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIImage *displayImage = [UIImage imageNamed:@"placeholder"];
        NSString *docsPath = [Common getDocumentDirectory];
        NSString *localImagePath = [docsPath stringByAppendingPathComponent:_imageName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localImagePath]) {
            displayImage = [UIImage imageWithContentsOfFile:localImagePath];
        }
        _scrollView.displayImage = displayImage;
    } failure:^{
        _imageLoaded = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

// (this can also be defined in Info.plist via UISupportedInterfaceOrientations)
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)showBarViews:(UITapGestureRecognizer *)gesture {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowBarView object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFinishDownloadAnImage object:nil];
}
@end
