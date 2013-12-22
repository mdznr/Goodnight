//
//  GNTimesViewController.h
//  Goodnight
//
//  Created by Matt Zanchelli on 9/19/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	GNTimesViewControllerModeSleepTimes,
	GNTimesViewControllerModeWakeTimes
} GNTimesViewControllerMode;


@protocol GNTimesViewControllerDelegate <NSObject>

- (void)timesViewControllerRequestsDismissal;

- (void)timesViewControllerDidSetAlarm:(NSDate *)alarmTime;
- (void)timesViewControllerDidCancelAlarm;

- (void)timesViewControllerDidSetSleepReminder:(NSDate *)reminderTime forWakeUpTime:(NSDate *)wakeTime;
- (void)timesViewControllerDidCancelSleepReminder;

@end


@interface GNTimesViewController : UIViewController

///
@property (nonatomic) id<GNTimesViewControllerDelegate> delegate;

/// The mode of the view controller.
@property (nonatomic) GNTimesViewControllerMode mode;

/// The goal date. This is where the sleep cycle time offsets are calculated from.
/// @discussion Times displayed in @c GNTimesViewControllerModeSleepTimes mode are subtracted from the given time
/// @discussion Times displayed in @c GNTimesViewControllerModeWakeTimes mode are added from the given time
@property (strong, nonatomic) NSDate *date;

@property (nonatomic, readonly, getter = isShowingTimes) BOOL showingTimes;


///
- (void)animateIn;

///
- (void)animateOut;

@end
