//
//  AppDelegate.m
//  MangaApp
//
//  Created by ThanhLD on 4/11/15.
//  Copyright (c) 2015 ThanhLD. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <MagicalRecord/NSPersistentStore+MagicalRecord.h>
#import "StaminaConfig.h"
#import "TestFairy.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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
    
    
    //UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
    
    __block UIBackgroundTaskIdentifier background_task; //Create a task object
    
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
        [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
        background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
        
        //System will be shutting down the app at any point in time now
    }];
    
    //Background tasks require you to use asyncrous tasks
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Perform your tasks that your application requires
        
        NSLog(@"\n\nRunning in the background!\n\n");
        
        [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
        background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
    });
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
    
    //self.backgroundTransferCompletionHandler = completionHandler;
    
}
@end
