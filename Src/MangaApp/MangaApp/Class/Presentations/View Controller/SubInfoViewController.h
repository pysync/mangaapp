//
//  SubInfoViewController.h
//  MangaApp
//
//  Created by ThanhLD on 4/16/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubInfoViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, copy) void (^didClickCloseButton)();
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
