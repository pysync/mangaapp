//
//  Common.m
//  MangaApp
//
//  Created by ThanhLD on 5/5/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
@end
