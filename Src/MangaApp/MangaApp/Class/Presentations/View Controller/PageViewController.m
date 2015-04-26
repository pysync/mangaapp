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
@property (strong, nonatomic) UIImageView *zoomImage;
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
    _imageScrollView.frame = viewFrame;
    _imageScrollView.contentSize = viewFrame.size;
    
    UIImage *currentImage = [UIImage imageNamed:@"splash.png"];
    CGSize imageSize = currentImage.size;
    _imageView.image = currentImage;
    
    
    float ratio = [self getRatioFromViewSize:viewFrame.size andImageSize:imageSize];
    float imageWidth = currentImage.size.width * ratio;
    float imageHeight = currentImage.size.height * ratio;
    float originX = (viewFrame.size.width - imageWidth)/2;
    float originY = (viewFrame.size.height - imageHeight)/2;
    _imageView.frame = CGRectMake(originX, originY, imageWidth, imageHeight);
    
    _zoomImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, imageWidth, imageHeight)];
    _zoomImage.image = currentImage;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bouncesZoom = YES;
    scrollView.maximumZoomScale = 4.0f;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.delegate = self;
    [scrollView addSubview:_zoomImage];
    
    self.view = scrollView;
    //_widthContraint.constant = imageWidth;
    //_heightContraint.constant = imageHeight;
    //[_imageView updateConstraintsIfNeeded];
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
    return _zoomImage;
}
@end
