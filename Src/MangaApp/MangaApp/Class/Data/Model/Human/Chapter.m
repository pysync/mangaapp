#import "Chapter.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface Chapter ()

// Private interface goes here.

@end

@implementation Chapter

// Custom logic goes here.
+(Chapter *)MR_createEntityWithJSONModel:(ChapterJSONModel *)chap {
    Chapter *chapEntity = [self MR_createEntity];
    chapEntity.chapterID = @(chap.chapterID.integerValue);
    chapEntity.chapterName = chap.chapterName;
    chapEntity.dirPrefix = chap.dirPrefix;
    chapEntity.pageCount = @(chap.pageCount.integerValue);
    chapEntity.pagePrefix = chap.pagePrefix;
    chapEntity.freeFlg = @(chap.freeFlg.integerValue);
    chapEntity.cost = @(chap.cost.doubleValue);
    chapEntity.ext = chap.ext;
    chapEntity.isDownloaded = @(0);
    
    return chapEntity;
}
@end
