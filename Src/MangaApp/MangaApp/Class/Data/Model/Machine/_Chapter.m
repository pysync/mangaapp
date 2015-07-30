// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.m instead.

#import "_Chapter.h"

const struct ChapterAttributes ChapterAttributes = {
	.chapterID = @"chapterID",
	.chapterName = @"chapterName",
	.cost = @"cost",
	.dirPrefix = @"dirPrefix",
	.ext = @"ext",
	.freeFlg = @"freeFlg",
	.isDownloaded = @"isDownloaded",
	.pageCount = @"pageCount",
	.pagePrefix = @"pagePrefix",
};

@implementation ChapterID
@end

@implementation _Chapter

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Chapter" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Chapter";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Chapter" inManagedObjectContext:moc_];
}

- (ChapterID*)objectID {
	return (ChapterID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"chapterIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"chapterID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"costValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cost"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"freeFlgValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"freeFlg"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isDownloadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDownloaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pageCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pageCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic chapterID;

- (int32_t)chapterIDValue {
	NSNumber *result = [self chapterID];
	return [result intValue];
}

- (void)setChapterIDValue:(int32_t)value_ {
	[self setChapterID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveChapterIDValue {
	NSNumber *result = [self primitiveChapterID];
	return [result intValue];
}

- (void)setPrimitiveChapterIDValue:(int32_t)value_ {
	[self setPrimitiveChapterID:[NSNumber numberWithInt:value_]];
}

@dynamic chapterName;

@dynamic cost;

- (int32_t)costValue {
	NSNumber *result = [self cost];
	return [result intValue];
}

- (void)setCostValue:(int32_t)value_ {
	[self setCost:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCostValue {
	NSNumber *result = [self primitiveCost];
	return [result intValue];
}

- (void)setPrimitiveCostValue:(int32_t)value_ {
	[self setPrimitiveCost:[NSNumber numberWithInt:value_]];
}

@dynamic dirPrefix;

@dynamic ext;

@dynamic freeFlg;

- (int16_t)freeFlgValue {
	NSNumber *result = [self freeFlg];
	return [result shortValue];
}

- (void)setFreeFlgValue:(int16_t)value_ {
	[self setFreeFlg:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveFreeFlgValue {
	NSNumber *result = [self primitiveFreeFlg];
	return [result shortValue];
}

- (void)setPrimitiveFreeFlgValue:(int16_t)value_ {
	[self setPrimitiveFreeFlg:[NSNumber numberWithShort:value_]];
}

@dynamic isDownloaded;

- (BOOL)isDownloadedValue {
	NSNumber *result = [self isDownloaded];
	return [result boolValue];
}

- (void)setIsDownloadedValue:(BOOL)value_ {
	[self setIsDownloaded:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsDownloadedValue {
	NSNumber *result = [self primitiveIsDownloaded];
	return [result boolValue];
}

- (void)setPrimitiveIsDownloadedValue:(BOOL)value_ {
	[self setPrimitiveIsDownloaded:[NSNumber numberWithBool:value_]];
}

@dynamic pageCount;

- (int32_t)pageCountValue {
	NSNumber *result = [self pageCount];
	return [result intValue];
}

- (void)setPageCountValue:(int32_t)value_ {
	[self setPageCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePageCountValue {
	NSNumber *result = [self primitivePageCount];
	return [result intValue];
}

- (void)setPrimitivePageCountValue:(int32_t)value_ {
	[self setPrimitivePageCount:[NSNumber numberWithInt:value_]];
}

@dynamic pagePrefix;

@end

