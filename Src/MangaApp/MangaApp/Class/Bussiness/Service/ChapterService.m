//
//  ChapterService.m
//  MangaApp
//
//  Created by ThanhLD on 4/25/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "ChapterService.h"
#import <AFNetworking/AFNetworking.h>
#import "Definition.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ChapTracker.h"
#import "StaminaConfig.h"
#import "TrackerModel.h"

@interface ChapterService()
@property (nonatomic, strong) NSMutableArray *imagesDownloading;
@end

@implementation ChapterService

- (instancetype)initWithModel:(ChapterModel *)chapModel
{
    self = [super init];
    if (self) {
        _imagesDownloading = [[NSMutableArray alloc] initWithCapacity:0];
        _chapterModel = chapModel;
    }
    return self;
}

- (void)getChapHistoryWithChapName:(NSNumber *)chapterID {
    ChapTracker *tracker = [ChapTracker MR_findFirstByAttribute:@"chapterID" withValue:chapterID];
    StaminaConfig *config = [StaminaConfig sharedConfig];
    
    if (tracker) {
        TrackerModel *trackerModel = [[TrackerModel alloc] initWithChapTracker:tracker];
        config.tracker = trackerModel;
    }else {
        TrackerModel *trackerModel = [[TrackerModel alloc] initWithChapID:chapterID];
        config.tracker = trackerModel;
    }
}

- (void)downloadImageWithName:(NSString *)imageName success:(void (^)())successBlock failure:(void (^)())failBlock {
//    if (![_imagesDownloading containsObject:imageName]) {
//        [_imagesDownloading addObject:imageName];
//        
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//        
//        NSString *baseURL = [kBaseUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", chapterModel.dirPrefix, chapterModel.chapterID]];
//        NSString *fullURL = [baseURL stringByAppendingPathComponent:imageName];
//        NSURL *URL = [NSURL URLWithString:fullURL];
//        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//        
//        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//            NSLog(@"File downloaded to: %@", filePath);
//            NSString *imageDownloaded = filePath.absoluteString.lastPathComponent;
//            if ([_imagesDownloading containsObject:imageDownloaded]) {
//                [_imagesDownloading removeObject:imageDownloaded];
//            }
//            
//            if (error) {
//                if (failBlock) {
//                    failBlock();
//                }
//            }else {
//                if (successBlock) {
//                    successBlock();
//                }
//            }
//        }];
//        [downloadTask resume];
//    }
}
@end
