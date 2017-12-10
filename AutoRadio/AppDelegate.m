//
//  AppDelegate.m
//  AutoRadio
//
//  Created by POLA on 13/02/15.
//  Copyright (c) 2015 POLA. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"

@interface AppDelegate ()


@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sleep(1);
    
    NSError *sessionError = nil;
    NSError *activationError = nil;
    audioSession = [AVAudioSession sharedInstance];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationError];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Google analytics -----------------------
    
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-64423466-1​"];
    
    // Provide unhandled exceptions reports.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Enable Remarketing, Demographics & Interests reports. Requires the libAdIdAccess library
    // and the AdSupport framework.
    // https://developers.google.com/analytics/devguides/collection/ios/display-features
    //tracker.allowIDFACollection = YES;
    
    // Google analytics -----------------------
    
    
    // Pushbots -----------------------
    self.PushbotsClient = [[Pushbots alloc] initWithAppId:@"55896236177959fa488b4567" prompt:YES];
    //Handle notification when the user click it, while app is closed.
    //This method will show an alert to the user.
    [self receivedPush:launchOptions];
    
    // Pushbots -----------------------
    
    return YES;
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // This method will be called everytime you open the app
    // Register the deviceToken on Pushbots
    [[Pushbots sharedInstance] registerOnPushbots:deviceToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Notification Registration Error %@", [error userInfo]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //Handle notification when the user click it while app is running in background or foreground.
    //Check for openURL [optional]
    [Pushbots openURL:userInfo];
    //Track notification only if the application opened from Background by clicking on the notification.
    if (application.applicationState == UIApplicationStateInactive) {
        [self.PushbotsClient trackPushNotificationOpenedWithPayload:userInfo];
    }
    
    //The application was already active when the user got the notification, just show an alert.
    //That should *not* be considered open from Push.
    if (application.applicationState == UIApplicationStateActive) {
        NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
        NSString *alertString = [notificationDict objectForKey:@"alert"];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Push Notification Received" message:alertString delegate:self
                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    //[self receivedPush:userInfo];
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
    [[Pushbots sharedInstance] clearBadgeCount];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) receivedPush:(NSDictionary *)userInfo {
    //Try to get Notification from [didReceiveRemoteNotification] dictionary
    NSDictionary *pushNotification = [userInfo objectForKey:@"aps"];
    
    if(!pushNotification) {
        //Try as launchOptions dictionary
        userInfo = [userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        pushNotification = [userInfo objectForKey:@"aps"];
    }
    
    if (!pushNotification)
        return;
    
    //Get notification payload data [Custom fields]
    
    //For example: get viewControllerIdentifer for deep linking
    NSString* notificationViewControllerIdentifer = [userInfo objectForKey:@"notification_identifier"];
    
    //Set the default viewController Identifer
    if(!notificationViewControllerIdentifer)
        notificationViewControllerIdentifer = @"home";
    
    UIAlertView *message =
    [[UIAlertView alloc] initWithTitle:@"Notification"
                               message:[pushNotification valueForKey:@"alert"]
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles: @"OK",
     nil];
    
    [message show];
    return;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        //[[Pushbots sharedInstance] OpenedNotification];
    }
}

@end
