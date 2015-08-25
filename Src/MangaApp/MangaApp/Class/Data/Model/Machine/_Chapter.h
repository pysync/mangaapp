// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.h instead.

#import <CoreData/CoreData.h>

extern const struct ChapterAttributes {
	__unsafe_unretained NSString *chapterID;
	__unsafe_unretained NSString *chapterName;
	__unsafe_unretained NSString *cost;
	__unsafe_unretained NSString *dirPrefix;
	__unsafe_unretained NSString *ext;
	__unsafe_unretained NSString *freeFlg;
	__unsafe_unretained NSString *isDownloaded;
	__unsafe_unretained NSString *pageCount;
	__unsafe_unretained NSString *pagePrefix;
} ChapterAttributes;

@interface ChapterID : NSManagedObjectID {}
@end

@interface _Chapter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ChapterID* objectID;

@property (nonatomic, strong) NSNumber* chapterID;

@property (atomic) int32_t chapterIDValue;
- (int32_t)chapterIDValue;
- (void)setChapterIDValue:(int32_t)value_;

//- (BOOL)validateChapterID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* chapterName;

//- (BOOL)validateChapterName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* cost;

@property (atomic) int32_t costValue;
- (int32_t)costValue;
- (void)setCostValue:(int32_t)value_;

//- (BOOL)validateCost:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* dirPrefix;

//- (BOOL)validateDirPrefix:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* ext;

//- (BOOL)validateExt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* freeFlg;

@property (atomic) int16_t freeFlgValue;
- (int16_t)freeFlgValue;
- (void)setFreeFlgValue:(int16_t)value_;

//- (BOOL)validateFreeFlg:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isDownloaded;

@property (atomic) BOOL isDownloadedValue;
- (BOOL)isDownloadedValue;
- (void)setIsDownloadedValue:(BOOL)value_;

//- (BOOL)validateIsDownloaded:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* pageCount;

@property (atomic) int32_t pageCountValue;
- (int32_t)pageCountValue;
- (void)setPageCountValue:(int32_t)value_;

//- (BOOL)validatePageCount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pagePrefix;

//- (BOOL)validatePagePrefix:(id*)value_ error:(NSError**)error_;

@end

@interface _Chapter (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveChapterID;
- (void)setPrimitiveChapterID:(NSNumber*)value;

- (int32_t)primitiveChapterIDValue;
- (void)setPrimitiveChapterIDValue:(int32_t)value_;

- (NSString*)primitiveChapterName;
- (void)setPrimitiveChapterName:(NSString*)value;

- (NSNumber*)primitiveCost;
- (void)setPrimitiveCost:(NSNumber*)value;

- (int32_t)primitiveCostValue;
- (void)setPrimitiveCostValue:(int32_t)value_;

- (NSString*)primitiveDirPrefix;
- (void)setPrimitiveDirPrefix:(NSString*)value;

- (NSString*)primitiveExt;
- (void)setPrimitiveExt:(NSString*)value;

- (NSNumber*)primitiveFreeFlg;
- (void)setPrimitiveFreeFlg:(NSNumber*)value;

- (int16_t)primitiveFreeFlgValue;
- (void)setPrimitiveFreeFlgValue:(int16_t)value_;

- (NSNumber*)primitiveIsDownloaded;
- (void)setPrimitiveIsDownloaded:(NSNumber*)value;

- (BOOL)primitiveIsDownloadedValue;
- (void)setPrimitiveIsDownloadedValue:(BOOL)value_;

- (NSNumber*)primitivePageCount;
- (void)setPrimitivePageCount:(NSNumber*)value;

- (int32_t)primitivePageCountValue;
- (void)setPrimitivePageCountValue:(int32_t)value_;

- (NSString*)primitivePagePrefix;
- (void)setPrimitivePagePrefix:(NSString*)value;

@end
