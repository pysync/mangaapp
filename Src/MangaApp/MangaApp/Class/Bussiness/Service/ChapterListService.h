//
//  ChapterListService.h
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChapterListService : NSObject

@property (strong, nonatomic) NSMutableArray *listChapters;

- (void)getDataFromJSONSuccess:(void(^)())successBlock failure:(void(^)())failBlock;
@end
