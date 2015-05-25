//
//  NewsViewPopup.h
//  MangaApp
//
//  Created by ThanhLD on 5/25/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewPopup : UIView <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (nonatomic, copy) void (^didCloseNewsCompletion)();

- (void)loadWebView;
- (IBAction)onCloseButton:(id)sender;
@end
