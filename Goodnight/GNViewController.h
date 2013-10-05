//
//  GNViewController.h
//  Goodnight
//
//  Created by Matt Zanchelli on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	GNViewControllerModeSetSleepTime,
	GNViewControllerModeSetWakeTime
} GNViewControllerMode;

@interface GNViewController : UIViewController

///
@property (nonatomic) GNViewControllerMode mode;

/// Update the date picker to be the current time
- (void)updateDatePicker;

@end
