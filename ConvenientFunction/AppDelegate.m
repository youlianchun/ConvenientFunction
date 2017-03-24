//
//  AppDelegate.m
//  ConvenientFunction
//
//  Created by YLCHUN on 16/9/15.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "AppDelegate.h"
#import "CFunction.h"

void CLog(NSString *format, ...) {
    va_list argumentList;
    va_start(argumentList, format);
    NSMutableString * message = [[NSMutableString alloc] initWithFormat:format
                                                              arguments:argumentList];
    
    NSLogv(message, argumentList);
    va_end(argumentList);
}



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    CLog(@"%@,%d",@"2",2);
//    timerCode(nil, 0, 0.01, ^(int dot) {
//        NSLog(@"%d",dot);
//    });
    
    for (int i=0; i<1000; i++) {
        globalDo(nil, 0,^{
            timerCode(nil, 0, 0.1, ^(int dot) {
//                printf("dot...\n");
            });
        });
    }
    
    tryDo(^{
        
    }, ^(NSException *exception) {
        if (exception) {
            
        }
        
    });
    
    doCodeDelay(self, 0.00001, ^{
        NSLog(@"11");
    });
    doCodeDelay(nil, 0.00002, ^{
        NSLog(@"22");
    });

    //    timerCodePlus(nil, 6, 1, ^(int dot, void(^inte)(int i)) {
    //        NSLog(@"%d",dot);
    //        if (dot==3) {
    //            inte(0);
    //            NSLog(@"--");
    //            [NSThread sleepForTimeInterval:3];
    //            NSLog(@"++");
    //            inte(1);
    //        }
    //    });
    //
    //    globalDo(nil, 0,^{
    //        doCodeDelay(nil, 3.02,^{
    //            NSLog(@"%@, 3.2",[NSThread isMainThread]?@"main":@"thread");//t
    //        });
    //    });
    //    doCodeDelay(nil, 3.01,^{
    //        NSLog(@"%@, 3.1",[NSThread mainThread]?@"main":@"thread");
    //    });
    //    doCodeDelay(nil, 3.01,^{
    //        NSLog(@"%@, 3.1_2",[NSThread mainThread]?@"main":@"thread");
    //    });
    ////    NSLog(@"_3");
    //    globalDo(nil, 0,^{
    //        NSLog(@"3");
    //    });
    
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

@end
