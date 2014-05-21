//
//  AppDelegate.m
//  PicturesqueScene
//
//  Created by Stan on 14-4-4.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //这个dispatch_async中提交的工作会在app主线程启动后的下一个run lopp中运行，此时app已经完成了载入并且将要显示第一帧画面，也就是系统会运行到`-[UIApplication _reportAppLaunchFinished]`之前。
    //用这个来在画面显示后，再发出通知执行后续的网络操作等等
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Lauched in %f seconds.", CFAbsoluteTimeGetCurrent());
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplicationFinishedLaunching" object:self];
    });
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    _viewController = [[ViewController alloc] init];
    self.window.rootViewController = _viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [_viewController.moviePlayer pause];
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
    [_viewController.moviePlayer play];
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
