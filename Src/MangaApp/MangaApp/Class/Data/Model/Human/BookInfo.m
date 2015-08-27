#import "BookInfo.h"
#import <MagicalRecord/MagicalRecord.h>

@interface BookInfo ()

// Private interface goes here.

@end

@implementation BookInfo

// Custom logic goes here.
+ (BookInfo *)MR_createEntityWithJSONModel:(BookInfoJSONModel *)book andContext:(NSManagedObjectContext *)context {
    BookInfo *bookEntity = [self MR_createEntityInContext:context];
    bookEntity.appID = book.appID;
    bookEntity.bookID = book.bookID;
    bookEntity.bookName = book.bookName;
    bookEntity.coverImage = book.coverImage;
    return bookEntity;
}
@end
