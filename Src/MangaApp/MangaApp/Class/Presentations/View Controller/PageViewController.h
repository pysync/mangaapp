//
//  PageViewController.h
//  MangaApp
//
//  Created by ThanhLD on 4/22/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic) NSInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

- (instancetype)initWithImageName:(NSString *)imageName;
@end
