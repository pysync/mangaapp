//
//  NewsViewPopup.m
//  MangaApp
//
//  Created by ThanhLD on 5/25/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "NewsViewPopup.h"
#import "Definition.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation NewsViewPopup

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)layoutSubviews {
    _titleLabel.text = NSLocalizedString(kNewsScreenLocalizable, nil);
    [_closeButton setTitle:NSLocalizedString(kCloseButtonLocalizable, nil) forState:UIControlStateNormal];
}
- (void)loadWebView {
    //[MBProgressHUD showHUDAddedTo:self animated:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html" inDirectory:nil];
    NSLog(@"%@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_contentWebView loadRequest:request];
}

- (IBAction)onCloseButton:(id)sender {
    if (self.didCloseNewsCompletion) {
        self.didCloseNewsCompletion();
    }
}

#pragma mark - UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[MBProgressHUD hideAllHUDsForView:self animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //[MBProgressHUD hideAllHUDsForView:self animated:YES];
}
@end
