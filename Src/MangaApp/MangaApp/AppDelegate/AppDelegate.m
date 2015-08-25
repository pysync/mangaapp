//
//  AppDelegate.m
//  MangaApp
//
//  Created by ThanhLD on 4/11/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <MagicalRecord/MagicalRecord.h>
#import "StaminaConfig.h"
#import "TestFairy.h"
#import "BackgroundSessionManager.h"
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Check Network
    [self checkNetworkReachability];
    
    // Setup TestFairy
    [TestFairy begin:@"dee385de1cbd3d58315afa1f532077fe7c9ef1cf"];
    
    // Setup Core Data
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"MangaApp.sqlite3"];
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:@"MangaApp.sqlite3"];
    NSLog(@"db path: %@", storeURL.absoluteString);
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"rScZnWJoTzLQ5ZkWYyqqHl1sg8d9jKq6usc5bGIi"
                  clientKey:@"Q5uufzW8LoIQsr17kcLSMgwES7NJRKGjZgAUn0q5"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[StaminaConfig sharedConfig] saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    NSAssert([[BackgroundSessionManager sharedManager].session.configuration.identifier isEqualToString:identifier], @"Identifiers didn't match");
    [BackgroundSessionManager sharedManager].savedCompletionHandler = completionHandler;
}

- (void)checkNetworkReachability {
    NSURL *baseURL = [NSURL URLWithString:@"http://www.apple.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    [manager.reachabilityManager startMonitoring];
}
@end
