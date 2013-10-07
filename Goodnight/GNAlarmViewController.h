//
//  GNAlarmViewController.h
//  Goodnight
//
//  Created by Matt Zanchelli on 10/6/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GNAlarmViewControllerDelegate <NSObject>

///
- (void)alarmViewControllerDidCancelAlarm;

@end


@interface GNAlarmViewController : UIViewController

///
@property (nonatomic) id<GNAlarmViewControllerDelegate> delegate;

///
- (CGRect)alarmTimeLabelFrame;

@end
