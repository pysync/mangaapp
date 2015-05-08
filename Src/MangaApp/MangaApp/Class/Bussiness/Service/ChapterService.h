//
//  ChapterService.h
//  MangaApp
//
//  Created by ThanhLD on 4/25/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterJSONModel.h"
#import "ChapterModel.h"

@interface ChapterService : NSObject

@property (strong, nonatomic) ChapterModel *chapterModel;

- (instancetype)initWithModel:(ChapterModel *)chapModel;
- (void)getChapHistoryWithChapName:(NSString *)chapName;
- (void)downloadImageWithName:(NSString *)imageName success:(void(^)())successBlock failure:(void(^)())failBlock;
@end
