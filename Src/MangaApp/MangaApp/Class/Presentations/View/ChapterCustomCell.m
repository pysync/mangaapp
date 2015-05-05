//
//  ChapterCustomCell.m
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterCustomCell.h"
#import "Definition.h"

#define kBgBeforeButtonColor [UIColor colorWithRed:27/255.0 green:27/255.0 blue:27/255.0 alpha:1.0]
#define kBgBeforeViewColor [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0]

#define kBgDownloadedButtonColor [UIColor colorWithRed:230/255.0 green:37/255.0 blue:37/255.0 alpha:1.0]
#define kBgDownloadedViewColor [UIColor whiteColor]

@implementation ChapterCustomCell

- (void)awakeFromNib {
    // Initialization code
    [self addObserver:self forKeyPath:@"downloadState" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (NSString *)getIdentifierCell {
    return @"ChapterCustomCell";
}

+ (CGFloat)getHeightCell {
    return 100.0f;
}

- (void)updateCellWithModel:(ChapterModel *)unitModel {
    _chapTitleLabel.text = @"Thumbnail chapter";
    if (unitModel.titleChap && unitModel.titleChap.length) {
        _chapNumberLabel.text = unitModel.titleChap;
    }else {
        _chapNumberLabel.text = @"";
    }
}

#pragma mark - Button Function
- (IBAction)onReadingButton:(id)sender {
    if (self.onStartReadingButton) {
        self.onStartReadingButton();
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    switch (_downloadState) {
        case kBeforeDownloadState:{
            _readingButton.enabled = YES;
            [_readingButton setTitle:kBeforeDownload forState:UIControlStateNormal];
            [_readingButton setBackgroundColor:kBgBeforeButtonColor];
            [_readingButton setTitleColor:kBgBeforeViewColor forState:UIControlStateNormal];
            _subContentView.backgroundColor = kBgBeforeViewColor;
            break;
        }
            
        case kDownloadingState:{
            _readingButton.enabled = NO;
            [_readingButton setTitle:kDownloading forState:UIControlStateNormal];
            [_readingButton setBackgroundColor:kBgBeforeButtonColor];
            [_readingButton setTitleColor:kBgBeforeViewColor forState:UIControlStateNormal];
            _subContentView.backgroundColor = kBgBeforeViewColor;
            break;
        }
            
        case kDownloadedState:{
            _readingButton.enabled = YES;
            [_readingButton setTitle:kDeleteChapter forState:UIControlStateNormal];
            [_readingButton setBackgroundColor:kBgDownloadedButtonColor];
            [_readingButton setTitleColor:kBgDownloadedViewColor forState:UIControlStateNormal];
            _subContentView.backgroundColor = kBgDownloadedViewColor;
            break;
        }
            
        default:
            break;
    }
}
@end
