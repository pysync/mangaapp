// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.m instead.

#import "_Chapter.h"

const struct ChapterAttributes ChapterAttributes = {
	.chapterNumber = @"chapterNumber",
	.chapterTitle = @"chapterTitle",
	.isDownloaded = @"isDownloaded",
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

	if ([key isEqualToString:@"chapterNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"chapterNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isDownloadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDownloaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic chapterNumber;

- (int16_t)chapterNumberValue {
	NSNumber *result = [self chapterNumber];
	return [result shortValue];
}

- (void)setChapterNumberValue:(int16_t)value_ {
	[self setChapterNumber:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveChapterNumberValue {
	NSNumber *result = [self primitiveChapterNumber];
	return [result shortValue];
}

- (void)setPrimitiveChapterNumberValue:(int16_t)value_ {
	[self setPrimitiveChapterNumber:[NSNumber numberWithShort:value_]];
}

@dynamic chapterTitle;

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

@end

