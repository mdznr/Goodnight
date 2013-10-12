//
//  GNSleepReminderViewController.h
//  Goodnight
//
//  Created by Matt Zanchelli on 10/11/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GNSleepReminderViewControllerDelegate <NSObject>

///
- (void)alarmViewControllerDidCancelReminder;

@end


@interface GNSleepReminderViewController : UIViewController

///
@property (nonatomic, assign) id<GNSleepReminderViewControllerDelegate> delegate;

///
- (CGRect)alarmTimeLabelFrame;

@end
