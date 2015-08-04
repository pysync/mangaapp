// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChapTracker.h instead.

#import <CoreData/CoreData.h>

extern const struct ChapTrackerAttributes {
	__unsafe_unretained NSString *chapterID;
	__unsafe_unretained NSString *pageName;
} ChapTrackerAttributes;

@interface ChapTrackerID : NSManagedObjectID {}
@end

@interface _ChapTracker : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ChapTrackerID* objectID;

@property (nonatomic, strong) NSNumber* chapterID;

@property (atomic) int32_t chapterIDValue;
- (int32_t)chapterIDValue;
- (void)setChapterIDValue:(int32_t)value_;

//- (BOOL)validateChapterID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pageName;

//- (BOOL)validatePageName:(id*)value_ error:(NSError**)error_;

@end

@interface _ChapTracker (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveChapterID;
- (void)setPrimitiveChapterID:(NSNumber*)value;

- (int32_t)primitiveChapterIDValue;
- (void)setPrimitiveChapterIDValue:(int32_t)value_;

- (NSString*)primitivePageName;
- (void)setPrimitivePageName:(NSString*)value;

@end
