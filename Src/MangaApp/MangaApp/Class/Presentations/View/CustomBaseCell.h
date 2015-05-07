//
//  CustomBaseCell.h
//  MangaApp
//
//  Created by ThanhLD on 4/24/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChapterJSONModel.h"

@interface CustomBaseCell : UITableViewCell
+ (NSString *)getIdentifierCell;
+ (CGFloat)getHeightCell;
- (void)updateCellWithModel:(ChapterJSONModel *)unitModel;
@end
