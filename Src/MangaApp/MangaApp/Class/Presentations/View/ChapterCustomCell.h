//
//  ChapterCustomCell.h
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterCustomCell : UITableViewCell

@property (nonatomic, copy) void (^onStartReadingButton)();

+ (NSString *)getIdentifier;
+ (CGFloat )getHeightOfCell;
- (IBAction)onReadingButton:(id)sender;
@end
