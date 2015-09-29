//
//  SubInfoViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/16/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "SubInfoViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SubInfoViewController ()

@end

@implementation SubInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadDataFromHTMLFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onCloseButton:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - Button Function
- (void)onCloseButton:(id)sender {
    if (self.didClickCloseButton) {
        self.didClickCloseButton();
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadDataFromHTMLFile {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *htmlFileName = @"about";
    switch (_subInfoType) {
        case kAboutScreen:
            htmlFileName = @"about";
            break;
        case kQAScreen:
            htmlFileName = @"qa";
            break;
        case kContactScreen:
            htmlFileName = @"contact";
            break;
        case kNewsScreen:
            htmlFileName = @"news";
            break;
        case kTermScreen:
            htmlFileName = @"term";
            break;
            
        default:
            break;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html" inDirectory:nil];
    NSLog(@"%@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
