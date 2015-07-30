//
//  ChapterModel.h
//  MangaApp
//
//  Created by ThanhLD on 4/22/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "JSONModel.h"

@protocol ChapterJSONModel

@end

@interface ChapterJSONModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *chapterID;
@property (nonatomic, strong) NSString<Optional> *chapterName;
@property (nonatomic, strong) NSString<Optional> *dirPrefix;
@property (nonatomic, strong) NSString<Optional> *pageCount;
@property (nonatomic, strong) NSString<Optional> *pagePrefix;
@property (nonatomic, strong) NSString<Optional> *freeFlg;
@property (nonatomic, strong) NSString<Optional> *cost;
@property (nonatomic, strong) NSString<Optional> *ext;
@end
