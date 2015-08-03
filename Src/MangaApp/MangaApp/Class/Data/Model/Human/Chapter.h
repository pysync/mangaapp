#import "_Chapter.h"
#import "ChapterJSONModel.h"

@interface Chapter : _Chapter {}
// Custom logic goes here.
+(Chapter *)MR_createEntityWithJSONModel:(ChapterJSONModel *)chap;
@end
