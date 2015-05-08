// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChapTracker.h instead.

#import <CoreData/CoreData.h>

extern const struct ChapTrackerAttributes {
	__unsafe_unretained NSString *chapName;
	__unsafe_unretained NSString *pageName;
} ChapTrackerAttributes;

@interface ChapTrackerID : NSManagedObjectID {}
@end

@interface _ChapTracker : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ChapTrackerID* objectID;

@property (nonatomic, strong) NSString* chapName;

//- (BOOL)validateChapName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pageName;

//- (BOOL)validatePageName:(id*)value_ error:(NSError**)error_;

@end

@interface _ChapTracker (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveChapName;
- (void)setPrimitiveChapName:(NSString*)value;

- (NSString*)primitivePageName;
- (void)setPrimitivePageName:(NSString*)value;

@end
