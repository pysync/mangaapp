// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Chapter.m instead.

#import "_Chapter.h"

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

	return keyPaths;
}

@end

