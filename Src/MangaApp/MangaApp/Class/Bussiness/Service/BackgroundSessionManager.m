//
//  BackgroundSessionManager.m
//  MangaApp
//
//  Created by ThanhLD on 5/15/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "BackgroundSessionManager.h"
#import "Common.h"

static NSString * const kBackgroundSessionIdentifier = @"com.domain.backgroundsession";

@implementation BackgroundSessionManager

+ (instancetype)sharedManager
{
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundSessionIdentifier];
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        [self configureDownloadFinished];            // when download done, save file
        [self configureBackgroundSessionFinished];   // when entire background session done, call completion handler
        //[self configureAuthentication];              // my server uses authentication, so let's handle that; if you don't use authentication challenges, you can remove this
    }
    return self;
}

- (void)configureDownloadFinished
{
    // just save the downloaded file to documents folder using filename from URL
    
    [self setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
        if ([downloadTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)downloadTask.response statusCode];
            if (statusCode != 200) {
                // handle error here, e.g.
                
                NSLog(@"%@ failed (statusCode = %ld)", [downloadTask.originalRequest.URL lastPathComponent], (long)statusCode);
                return nil;
            }
        }
        
        NSString *fileName      = [downloadTask.originalRequest.URL lastPathComponent];
        NSString *documentsPath = [Common getDocumentDirectory];
        
        NSArray *components = [downloadTask.originalRequest.URL pathComponents];
        NSString *chapterName = components[components.count - 2];
        
        documentsPath = [documentsPath stringByAppendingPathComponent:chapterName];
        
        BOOL isDir = YES;
        NSError *err;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:documentsPath isDirectory:&isDir]) {
            if (![fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:&err]) {
                NSLog(@"Create directory fail");
            }
        }
        
        NSString *path = [documentsPath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:path];
    }];
    
    [self setTaskDidCompleteBlock:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        if (error) {
            // handle error here, e.g.,
            
            NSLog(@"%@: %@", [task.originalRequest.URL lastPathComponent], error);
        }
    }];
}

- (void)configureBackgroundSessionFinished
{
    typeof(self) __weak weakSelf = self;
    
    [self setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        if (weakSelf.savedCompletionHandler) {
            weakSelf.savedCompletionHandler();
            weakSelf.savedCompletionHandler = nil;
        }
    }];
}

- (void)configureAuthentication
{
    NSURLCredential *myCredential = [NSURLCredential credentialWithUser:@"userid" password:@"password" persistence:NSURLCredentialPersistenceForSession];
    
    [self setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *credential) {
        if (challenge.previousFailureCount == 0) {
            *credential = myCredential;
            return NSURLSessionAuthChallengeUseCredential;
        } else {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }];
}
@end
