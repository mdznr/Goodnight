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

/// Returns an NSDate object with the correct time for an alarm
/// @param date An instance of NSDate with the correct time, but not necessarily the correct date.
+ (NSDate *)appropriateAlarmTimeFromDate:(NSDate *)date;

/// Shared alarm singleton
+ (GNAlarm *)sharedAlarm;

/// Cancels alarm or sleep reminder
- (void)cancel;

/// Sets an alarm
- (void)setAlarm:(NSDate *)alarmTime;

// Sets a reminder for a time to wake up at
- (void)setReminder:(NSDate *)reminderTime forWakeUpTime:(NSDate *)wakeUpTime;

@end
