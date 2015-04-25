//
//  ResponseModel.h
//  MangaApp
//
//  Created by ThanhLD on 4/22/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "JSONModel.h"
#import "ChapterModel.h"

@interface ResponseModel : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSArray<Optional, ChapterModel> *data;
@end
