//
//  GNAlarm.m
//  Goodnight
//
//  Created by Matt Zanchelli on 11/22/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import "GNAlarm.h"

#define ALARM_TIME_INTERVAL 60
#define NUMBER_OF_ALARMS 5

@interface GNAlarm ()

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UILocalNotification *notification;

@end

@implementation GNAlarm

static GNAlarm *_sharedAlarm = nil;

+ (GNAlarm *)sharedAlarm
{
    @synchronized( [GNAlarm class] ) {
        if (!_sharedAlarm) {
            _sharedAlarm = [[self alloc] init];
		}
        return _sharedAlarm;
    }
    return nil;
}

- (void)cancel
{
	_notification = nil;
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)setAlarm:(NSDate *)alarmTime
{
	// Cancel all other notifications
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	_notification = [[UILocalNotification alloc] init];
	_notification.userInfo = @{kNotificationType: @(GNAlarmNotificationTypeWakeUp)};
	_notification.fireDate = alarmTime;
	_notification.alertBody = @"Good Morning";
	_notification.alertAction = @"Wake Up";
	
	_notification.soundName = @"Pendulum.m4a";
	
#warning launch image should be dawn
	_notification.alertLaunchImage = @"";
	
	[[UIApplication sharedApplication] scheduleLocalNotification:_notification];
}

- (void)setReminder:(NSDate *)reminderTime forWakeUpTime:(NSDate *)wakeUpTime
{
	// Cancel all other notifications
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	_notification = [[UILocalNotification alloc] init];
	_notification.userInfo = @{kNotificationType: @(GNAlarmNotificationTypeBedtime)};
	_notification.fireDate = reminderTime;
	_notification.alertBody = @"Good Morning";
	_notification.alertAction = @"Wake Up";
	
	_notification.soundName = @"Goodnight.mp3";
	
#warning launch image should be dusk
	_notification.alertLaunchImage = @"";
	
	[[UIApplication sharedApplication] scheduleLocalNotification:_notification];
}

@end
