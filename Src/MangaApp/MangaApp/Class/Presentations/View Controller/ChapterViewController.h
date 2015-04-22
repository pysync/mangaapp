//
//  ChapterViewController.h
//  MangaApp
//
//  Created by ThanhLD on 4/19/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contentScollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (nonatomic, strong) NSArray *imageList;

- (IBAction)onBackButton:(id)sender;
@end
