// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookInfo.h instead.

#import <CoreData/CoreData.h>

extern const struct BookInfoAttributes {
	__unsafe_unretained NSString *appID;
	__unsafe_unretained NSString *bookID;
	__unsafe_unretained NSString *bookName;
	__unsafe_unretained NSString *coverImage;
} BookInfoAttributes;

@interface BookInfoID : NSManagedObjectID {}
@end

@interface _BookInfo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BookInfoID* objectID;

@property (nonatomic, strong) NSString* appID;

//- (BOOL)validateAppID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* bookID;

//- (BOOL)validateBookID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* bookName;

//- (BOOL)validateBookName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coverImage;

//- (BOOL)validateCoverImage:(id*)value_ error:(NSError**)error_;

@end

@interface _BookInfo (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAppID;
- (void)setPrimitiveAppID:(NSString*)value;

- (NSString*)primitiveBookID;
- (void)setPrimitiveBookID:(NSString*)value;

- (NSString*)primitiveBookName;
- (void)setPrimitiveBookName:(NSString*)value;

- (NSString*)primitiveCoverImage;
- (void)setPrimitiveCoverImage:(NSString*)value;

@end
