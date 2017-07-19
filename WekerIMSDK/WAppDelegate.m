//
//  WAppDelegate.m
//  WekerCloudIM
//
//  Created by huahua0809 on 05/15/2017.
//  Copyright (c) 2017 huahua0809. All rights reserved.
//

#import "WAppDelegate.h"
#import <WekerIM/WekerIM.h>
#import "WDeviceViewController.h"
#import "WViewController.h"


@implementation WAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[WClient sharedManager] initializeSDKWithDevApnsCertName:@"CloudDev" disApnsCertName:@"CloudDis"];
    [self registerNotification:application];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SwitchRootViewController" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self switchRootViewController];
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self switchRootViewController];
    
    return YES;
}

-(void)switchRootViewController {
    if ([WClient sharedManager].userAccount) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[WDeviceViewController new]];
        self.window.rootViewController = nav;
    } else {
        WViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = vc;
    }
}

/**  注册本地通知  */
-(void)registerNotification:(UIApplication *)application {
    
    //iOS8.0之后注册离线推送
    [application registerForRemoteNotifications];
    UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound |
    UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    
    
    //注册本地推送
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[WClient sharedManager] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[WClient sharedManager] applicationWillEnterForeground:application];
}

@end
