//
//  AppDelegate.m
//  Health
//
//  Created by Bas Oppenheim on 08-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self copyPlist];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if (![settings objectForKey:@"launched"])
    {
        [settings setBool:true forKey:@"launched"];
        [settings setFloat:2.5 forKey:@"dailyWaterTarget"];
        [settings setInteger:0 forKey:@"waterContentIndex"];
    }
    
    [settings synchronize];
    
    // [self createUIColors];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

- (void) copyPlist {
    
    // For InputScores.plist :
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"InputScores.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //check if the file exists already in users documents folder
    //if file does not exist copy it from the application bundle Plist file
    if ( ![fileManager fileExistsAtPath:path] ) {
        NSLog(@"copying database to users documents");
        NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:@"InputScores" ofType:@"plist"];
        [fileManager copyItemAtPath:pathToSettingsInBundle toPath:path error:&error];
    }
    //if file is already there do nothing
    else {
        NSLog(@"users database already configured");
    }
    
    // For DailyScores.plist :
    
    path = [documentsDirectory stringByAppendingPathComponent:@"DailyScores.plist"];
    fileManager = [NSFileManager defaultManager];
    
    //check if the file exists already in users documents folder
    //if file does not exist copy it from the application bundle Plist file
    if ( ![fileManager fileExistsAtPath:path] ) {
        NSLog(@"copying database to users documents");
        NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:@"DailyScores" ofType:@"plist"];
        [fileManager copyItemAtPath:pathToSettingsInBundle toPath:path error:&error];
    }
    //if file is already there do nothing
    else {
        NSLog(@"users database already configured");
    }
}

- (void) createUIColors {
    UIColor* defaultTintColor = [UIColor colorWithRed:230/255.0 green:38/255.0 blue:43/255.0 alpha:1];
    
    [[UINavigationBar appearance] setTintColor:defaultTintColor];
    [[UITabBar appearance] setTintColor:defaultTintColor];
}

@end
