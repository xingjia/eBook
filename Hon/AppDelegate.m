//
//  AppDelegate.m
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *libraryPath = [[NSBundle mainBundle] resourcePath];
    self.libraryContents = [NSArray array];
    self.libraryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:libraryPath error:nil];
    NSPredicate *txt = [NSPredicate predicateWithFormat:@"pathExtension == 'txt'"];
    self.libraryContents = [self.libraryContents filteredArrayUsingPredicate:txt];
    self.textFontSize = 17.0f;
    [self loadSettingsFromUserDefault];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveSettingsToUserDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveSettingsToUserDefault];
}

- (void)loadSettingsFromUserDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([[defaults objectForKey:@"nightMode"] boolValue])
        self.nightMode = [[defaults objectForKey:@"nightMode"] boolValue];
    else
        self.nightMode = NO;
    
    if([defaults floatForKey:@"textFontSize"])
       self.textFontSize = [defaults floatForKey:@"textFontSize"];
    else
        self.textFontSize = 17.0;
    
    if([defaults objectForKey:@"lastReadTitle"])
        self.lastReadTitle = [[defaults objectForKey:@"lastReadTitle"] mutableCopy];
    else
        self.lastReadTitle = [NSMutableDictionary dictionary];
}

- (void)saveSettingsToUserDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.textFontSize forKey:@"textFontSize"];
    [defaults setObject:self.lastReadTitle forKey:@"lastReadTitle"];
    NSLog(@"Saving Last Read: %@", [defaults objectForKey:@"lastReadTitle"]);
}

@end
