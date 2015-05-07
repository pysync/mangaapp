//
//  CustomBaseCell.m
//  MangaApp
//
//  Created by ThanhLD on 4/24/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "CustomBaseCell.h"

@implementation CustomBaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)getIdentifierCell {
    return NSStringFromClass([self class]);
}

+ (CGFloat)getHeightCell {
    return [self getHeightCell];
}

- (void)updateCellWithModel:(ChapterJSONModel *)unitModel{
    
}
@end
