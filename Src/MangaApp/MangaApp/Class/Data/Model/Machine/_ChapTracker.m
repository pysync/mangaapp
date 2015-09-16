// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChapTracker.m instead.

#import "_ChapTracker.h"

const struct ChapTrackerAttributes ChapTrackerAttributes = {
	.chapterID = @"chapterID",
	.pageName = @"pageName",
};

@implementation ChapTrackerID
@end

@implementation _ChapTracker

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ChapTracker" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ChapTracker";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ChapTracker" inManagedObjectContext:moc_];
}

- (ChapTrackerID*)objectID {
	return (ChapTrackerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"chapterIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"chapterID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pageNameValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pageName"];
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

@dynamic pageName;

- (int32_t)pageNameValue {
	NSNumber *result = [self pageName];
	return [result intValue];
}

- (void)setPageNameValue:(int32_t)value_ {
	[self setPageName:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePageNameValue {
	NSNumber *result = [self primitivePageName];
	return [result intValue];
}

- (void)setPrimitivePageNameValue:(int32_t)value_ {
	[self setPrimitivePageName:[NSNumber numberWithInt:value_]];
}

@end

