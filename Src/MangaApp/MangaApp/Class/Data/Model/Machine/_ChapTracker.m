// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChapTracker.m instead.

#import "_ChapTracker.h"

const struct ChapTrackerAttributes ChapTrackerAttributes = {
	.chapName = @"chapName",
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

	return keyPaths;
}

@dynamic chapName;

@dynamic pageName;

@end

