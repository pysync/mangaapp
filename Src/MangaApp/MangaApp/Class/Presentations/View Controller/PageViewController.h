//
//  PageViewController.h
//  MangaApp
//
//  Created by ThanhLD on 4/22/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic) NSInteger pageNumber;

- (instancetype)initWithImageName:(NSString *)imageName;
@end
