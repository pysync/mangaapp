// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookInfo.m instead.

#import "_BookInfo.h"

const struct BookInfoAttributes BookInfoAttributes = {
	.appID = @"appID",
	.bookID = @"bookID",
	.bookName = @"bookName",
	.coverImage = @"coverImage",
};

@implementation BookInfoID
@end

@implementation _BookInfo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookInfo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookInfo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookInfo" inManagedObjectContext:moc_];
}

- (BookInfoID*)objectID {
	return (BookInfoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic appID;

@dynamic bookID;

@dynamic bookName;

@dynamic coverImage;

@end

