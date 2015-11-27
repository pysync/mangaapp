//
//  PageViewController.m
//  MangaApp
//
//  Created by ThanhLD on 4/22/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraint;
@end

@implementation PageViewController

- (instancetype)initWithImageName:(NSString *)imageName
{
    self = [super init];
    if (self) {
        _imageName = imageName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect viewFrame = self.view.frame;
    UIImage *currentImage = [UIImage imageNamed:@"splash.png"];
    CGSize imageSize = currentImage.size;
    
    float ratio = [self getRatioFromViewSize:viewFrame.size andImageSize:imageSize];
    _widthContraint.constant = currentImage.size.width * ratio - 4;
    _heightContraint.constant = currentImage.size.height * ratio - 4;

    [_contentView updateConstraintsIfNeeded];
    [_imageScrollView setMaximumZoomScale:4.0f];
    _imageView.image = currentImage;
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect imageFrame = _contentView.frame;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float )getRatioFromViewSize:(CGSize )viewSize andImageSize:(CGSize )imageSize {
    float widthRatio = viewSize.width/imageSize.width;
    float heightRatio = viewSize.height/imageSize.height;
    
    return widthRatio > heightRatio ? heightRatio:widthRatio;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _contentView;
}
@end
