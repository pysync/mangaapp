//
//  BookInfoJSONModel.m
//  MangaApp
//
//  Created by ThanhLD on 8/27/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "BookInfoJSONModel.h"

@implementation BookInfoJSONModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"AppID": @"appID",
                                                       @"BookID": @"bookID",
                                                       @"BookName": @"bookName",
                                                       @"CoverImage": @"coverImage"
                                                       }];
}
@end
