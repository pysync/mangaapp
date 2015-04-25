//
//  ChapterCustomCell.m
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterCustomCell.h"

@implementation ChapterCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)getIdentifierCell {
    return @"ChapterCustomCell";
}

+ (CGFloat)getHeightCell {
    return 60.0f;
}

- (void)updateCellWithModel:(ChapterModel *)unitModel {
    _chapTitleLabel.text = @"ありがとう";
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
@end
