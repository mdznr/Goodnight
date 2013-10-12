//
//  GNSleepReminderViewController.h
//  Goodnight
//
//  Created by Matt on 10/11/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GNSleepReminderViewControllerDelegate <NSObject>

///
- (void)alarmViewControllerDidCancelAlarm;

@end


@interface GNSleepReminderViewController : UIViewController

///
@property (nonatomic, assign) id<GNSleepReminderViewControllerDelegate> delegate;

///
- (CGRect)alarmTimeLabelFrame;

@end
