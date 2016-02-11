//
//  AppDelegate.m
//  DemoLocalNotification
//
//  Created by zj－db0465 on 15/9/22.
//  Copyright © 2015年 icetime17. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    
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
    
    // appIcon上的消息提示个数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // 添加1Mins和3Mins的localNotification
#define kLocalNotificationTimeInterval_1Mins        (60*1)
#define kLocalNotificationTimeInterval_3Mins        (60*3)
    [self setLocalNotification:kLocalNotificationTimeInterval_1Mins];
    [self setLocalNotification:kLocalNotificationTimeInterval_3Mins];
}

- (void)setLocalNotification:(NSTimeInterval)timeInterval {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置提醒时间为20:00
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        dateComponents.hour = 20;
        dateComponents.minute = 0;
        NSDate *fireDate = [calendar dateFromComponents:dateComponents];
        
        fireDate = [NSDate date];
        
        notification.fireDate = [fireDate dateByAddingTimeInterval:timeInterval];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = [NSString stringWithFormat:@"Local Notification %f", timeInterval];
        notification.applicationIconBadgeNumber = 1;
        
#define LocalNotificationPeriod_1Mins   @"LocalNotificationPeriod_1Mins"
#define LocalNotificationPeriod_3Mins   @"LocalNotificationPeriod_3Mins"
        
        NSString *period;
        if (timeInterval == kLocalNotificationTimeInterval_1Mins) {
            period = LocalNotificationPeriod_1Mins;
        } else {
            period = LocalNotificationPeriod_3Mins;
        }
        
        notification.userInfo = @{
                                  @"id": period,
                                  };
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// APP运行中收到notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"notification : %@", notification);
    
    if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@"notification_1"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification" message:@"notification_1" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
