#import "_BookInfo.h"
#import "BookInfoJSONModel.h"

@interface BookInfo : _BookInfo {}
// Custom logic goes here.
+(BookInfo *)MR_createEntityWithJSONModel:(BookInfoJSONModel *)book andContext:(NSManagedObjectContext *)context;
@end
