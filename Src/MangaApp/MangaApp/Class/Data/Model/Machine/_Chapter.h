// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.h instead.

#import <CoreData/CoreData.h>

extern const struct ChapterAttributes {
	__unsafe_unretained NSString *chapterNumber;
	__unsafe_unretained NSString *chapterTitle;
	__unsafe_unretained NSString *isDownloaded;
} ChapterAttributes;

@interface ChapterID : NSManagedObjectID {}
@end

@interface _Chapter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ChapterID* objectID;

@property (nonatomic, strong) NSNumber* chapterNumber;

@property (atomic) int16_t chapterNumberValue;
- (int16_t)chapterNumberValue;
- (void)setChapterNumberValue:(int16_t)value_;

//- (BOOL)validateChapterNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* chapterTitle;

//- (BOOL)validateChapterTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isDownloaded;

@property (atomic) BOOL isDownloadedValue;
- (BOOL)isDownloadedValue;
- (void)setIsDownloadedValue:(BOOL)value_;

//- (BOOL)validateIsDownloaded:(id*)value_ error:(NSError**)error_;

@end

@interface _Chapter (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveChapterNumber;
- (void)setPrimitiveChapterNumber:(NSNumber*)value;

- (int16_t)primitiveChapterNumberValue;
- (void)setPrimitiveChapterNumberValue:(int16_t)value_;

- (NSString*)primitiveChapterTitle;
- (void)setPrimitiveChapterTitle:(NSString*)value;

- (NSNumber*)primitiveIsDownloaded;
- (void)setPrimitiveIsDownloaded:(NSNumber*)value;

- (BOOL)primitiveIsDownloadedValue;
- (void)setPrimitiveIsDownloadedValue:(BOOL)value_;

@end
