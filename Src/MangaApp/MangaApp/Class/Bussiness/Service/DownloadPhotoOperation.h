//
//  DownloadPhotoOperation.h
//  MangaApp
//
//  Created by ThanhLD on 8/25/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadPhotoOperation : NSOperation

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, copy) void (^didFinishDownload)();

- (instancetype)initWithURL:(NSURL *)photoURL;
@end
