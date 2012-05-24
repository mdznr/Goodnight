//
//  GNAlarm.h
//  Goodnight
//
//  Created by Matt Zanchelli on 5/20/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNAlarm : UILocalNotification

@property int numberOfCycles;
@property NSTimeInterval *alarmDuration;

- (void) setAnAlarm;

@end
