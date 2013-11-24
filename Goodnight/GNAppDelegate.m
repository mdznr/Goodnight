//
//  GNAppDelegate.m
//  Goodnight
//
//  Created by Matt on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNAppDelegate.h"
#import "MTZAlertView.h"

@interface GNAppDelegate () <MTZAlertViewDelegate>

@end

@implementation GNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	// If opening from alarm
	UILocalNotification *alarm = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	if ( alarm ) {
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
	}
	
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	if ( !notification ) return;
	
#warning this will still be called if the app didn't quit yet
	
	// Cancel all local notifications
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	// Handle the notification while the app is open by showing an alert
	MTZAlertView *alert;
	
	// Switch on GNAlarmNotificationType
	switch ( ((NSNumber *)[notification.userInfo objectForKey:kNotificationType]).unsignedIntegerValue )
	{
		case GNAlarmNotificationTypeBedtime:
		{
			alert = [[MTZAlertView alloc] initWithTitle:@"Bedtime Reminder"
											 andMessage:@"Try falling alseep now"];
			alert.cancelButtonTitle = @"Dismiss";
		} break;
		case GNAlarmNotificationTypeWakeUp:
		{
			alert = [[MTZAlertView alloc] initWithTitle:@"Good Morning!"
											 andMessage:@"Wake up"];
			alert.cancelButtonTitle = @"Snooze";
			[alert addButtonWithTitle:@"Stop Alarm" andBlock:^{}];
		} break;
	}
	
	// Add self as delegate of alert and show the alert
	alert.delegate = self;
	[alert show];
}


#pragma mark Alert View Delegate

- (void)alertViewDidTapCancelButton:(MTZAlertView *)alertView
{
#warning set another alarm for snooze (if it's a wake up alarm)
	NSLog(@"TODO: SNOOZE");
}


#pragma mark Active and Inactive
							
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
#warning update date picker
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
