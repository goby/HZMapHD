//
//  ZGSAppDelegate.m
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import "ZGSAppDelegate.h"
#import "ZGSViewController.h"

@implementation ZGSAppDelegate

@synthesize userData = _userData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveUserData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveUserData];
}

-(NSDictionary *)userData {
    if (!_userData) {
        NSDictionary *dict = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
                              stringByAppendingPathComponent:@"user_data.plist"];
        
        if ([fileManager fileExistsAtPath:filename]) {
            dict = [NSDictionary dictionaryWithContentsOfFile:filename];
        }
        
        _userData = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    return _userData;
}

-(void)saveUserData {
    id root = (id)self.window.rootViewController;
    [root saveMapConfig];
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
                          stringByAppendingPathComponent:@"user_data.plist"];
    [self.userData writeToFile:filename atomically:YES];
}

+ (ZGSAppDelegate *)sharedInstance {
    static ZGSAppDelegate *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [UIApplication sharedApplication].delegate;
    });
    
    return sharedInstance;
}

static NSString *_offlineDirectory = nil;
static NSString *_cacheDirectory = nil;

+ (NSString *)offlineDirectory {
    if (!_offlineDirectory) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        _offlineDirectory = [cacheDirectory stringByAppendingPathComponent:@"OfflineLayers"];
        BOOL isDir = YES;
        if (![fileManager fileExistsAtPath:_offlineDirectory isDirectory:&isDir]) {
            [fileManager createDirectoryAtPath:_offlineDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    return _offlineDirectory;
}

+ (NSString *)cacheDirectory {
    if (!_cacheDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cacheDirectory = [paths objectAtIndex:0];
        _cacheDirectory = [_cacheDirectory stringByAppendingPathComponent:@"MapCaches"];
        BOOL isDir = YES;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:_cacheDirectory isDirectory:&isDir]) {
            [fileManager createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    return _cacheDirectory;
}

@end
