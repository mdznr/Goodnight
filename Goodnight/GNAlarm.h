//
//  GNAlarm.h
//  Goodnight
//
//  Created by Matt Zanchelli on 11/22/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ENUM(NSUInteger, GNAlarmNotificationType) {
	GNAlarmNotificationTypeBedtime,
	GNAlarmNotificationTypeWakeUp
};

static NSString *kNotificationType = @"GNAlarmNotificationType";

@interface GNAlarm : NSObject

/// Shared alarm singleton
+ (GNAlarm *)sharedAlarm;

/// Cancels alarm or sleep reminder
- (void)cancel;

/// Sets an alarm
- (void)setAlarm:(NSDate *)alarmTime;

// Sets a reminder for a time to wake up at
- (void)setReminder:(NSDate *)reminderTime forWakeUpTime:(NSDate *)wakeUpTime;

@end
