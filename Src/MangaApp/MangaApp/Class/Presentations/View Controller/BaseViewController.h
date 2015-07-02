//
//  BaseViewController.h
//  MangaApp
//
//  Created by ThanhLD on 7/2/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface BaseViewController : UIViewController<GADInterstitialDelegate>
@property(nonatomic, strong) GADInterstitial *interstitial;
@end
