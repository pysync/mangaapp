//
//  ChapterCustomCell.h
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBaseCell.h"

typedef enum {
    kBeforeDownloadState = 1,
    kDownloadingState,
    kDownloadedState
}DownloadState;

@interface ChapterCustomCell : CustomBaseCell

@property (nonatomic, assign) DownloadState downloadState;
@property (nonatomic, copy) void (^onStartReadingButton)();
@property (weak, nonatomic) IBOutlet UILabel *chapNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *readingButton;
@property (weak, nonatomic) IBOutlet UIView *subContentView;

- (IBAction)onReadingButton:(id)sender;
@end
