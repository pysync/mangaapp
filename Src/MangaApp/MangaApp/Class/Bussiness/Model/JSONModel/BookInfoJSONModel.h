//
//  BookInfoJSONModel.h
//  MangaApp
//
//  Created by ThanhLD on 8/27/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "JSONModel.h"

@protocol BookInfoJSONModel

@end

@interface BookInfoJSONModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *appID;
@property (nonatomic, strong) NSString<Optional> *bookID;
@property (nonatomic, strong) NSString<Optional> *bookName;
@property (nonatomic, strong) NSString<Optional> *coverImage;
@end
