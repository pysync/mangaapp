//
//  Common.h
//  MangaApp
//
//  Created by ThanhLD on 5/5/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+(NSString *)getDocumentDirectory;
+(NSString *)getChapterDirectoryWithChapter:(NSString *)chapter;
@end
