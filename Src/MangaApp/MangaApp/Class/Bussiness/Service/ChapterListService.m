//
//  ChapterListService.m
//  MangaApp
//
//  Created by ThanhLD on 4/12/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterListService.h"
#import "ResponseModel.h"

@implementation ChapterListService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listChapters = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)getDataFromJSONSuccess:(void (^)())successBlock failure:(void (^)())failBlock {
    NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"define" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:pathFile encoding:NSUTF8StringEncoding error:nil];
    
    NSError* err = nil;
    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:jsonString error:&err];
    if (!err) {
        _listChapters = [responseModel.data mutableCopy];
        if (successBlock) {
            successBlock();
        }
    }else {
        if (failBlock) {
            failBlock();
        }
    }
}
@end
