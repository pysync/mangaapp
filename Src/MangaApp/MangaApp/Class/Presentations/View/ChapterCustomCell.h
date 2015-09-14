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
@property (nonatomic, copy) void (^onStartDownloadButton)();
@property (nonatomic, copy) void (^onStartRemoveButton)();
@property (nonatomic, copy) void (^onStartReadingButton)();
@property (weak, nonatomic) IBOutlet UILabel *chapNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIView *subContentView;
@property (weak, nonatomic) IBOutlet UIView *downloadView;
@property (weak, nonatomic) IBOutlet UIView *downloadedView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

- (IBAction)onDownloadButton:(id)sender;
- (IBAction)onRemoveButton:(id)sender;
- (IBAction)onReadingButton:(id)sender;
@end
