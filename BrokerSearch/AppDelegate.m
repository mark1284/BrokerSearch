//
//  AppDelegate.m
//  BrokerSearch
//
//  Created by Mark Houghton on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [_window makeKeyAndVisible];
    
    
    NSArray *images = [NSArray arrayWithObjects: @"aviva-logo0001" , @"aviva-logo0013" , @"aviva-logo0025" , @"aviva-logo0037",
                       @"aviva-logo0049" , @"aviva-logo0061" , @"aviva-logo0073" , @"aviva-logo0085",
                       @"aviva-logo0097" , @"aviva-logo0109" , @"aviva-logo0121" , @"aviva-logo0133",
                       @"aviva-logo0145" , @"aviva-logo0157" , @"aviva-logo0169" , @"aviva-logo0181",
                       @"aviva-logo0187" , @"aviva-logo0193" , @"aviva-logo0199" , @"aviva-logo0205",
                       @"aviva-logo0211" , @"aviva-logo0217" , @"aviva-logo0223" , @"aviva-logo0229",
                       @"aviva-logo0235" , @"aviva-logo0241" , @"aviva-logo0247", nil];
    
    
    splashImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 768, 1004)];
    
    NSMutableArray * imageArray = [NSMutableArray new];
    for(id imageName in images) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];            
        [imageArray addObject:image];
    }
    
    [_window addSubview:splashImageView];
    [_window bringSubviewToFront:splashImageView];
    
    
    splashImageView.animationImages = imageArray;
    splashImageView.animationDuration = 1.5;
    splashImageView.animationRepeatCount = 1;

    [splashImageView startAnimating];   
    
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
}

@end
