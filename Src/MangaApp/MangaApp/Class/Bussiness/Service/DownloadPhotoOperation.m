//
//  DownloadPhotoOperation.m
//  MangaApp
//
//  Created by ThanhLD on 8/25/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "DownloadPhotoOperation.h"
#import "BackgroundSessionManager.h"
#import "Definition.h"

@implementation DownloadPhotoOperation

- (instancetype)initWithURL:(NSURL *)photoURL
{
    self = [super init];
    if (self) {
        _photoURL = photoURL;
    }
    return self;
}

- (void)main {
    NSURLRequest *request = [NSURLRequest requestWithURL:_photoURL];
    
    NSURLSessionDownloadTask *downloadTask = [[BackgroundSessionManager sharedManager] downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return documentsDirectoryURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        // Push notification
        NSString *pathString = filePath.absoluteString;
        NSString *imageName = [pathString lastPathComponent];
        if (imageName && imageName.length) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownloadAnImage object:nil userInfo:@{kImageNameNotification: imageName}];
        }
        
        if (self.didFinishDownload) {
            self.didFinishDownload();
        }
    }];
    [downloadTask resume];
}

@end
