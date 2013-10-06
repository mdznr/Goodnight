//
//  GNTimePickerViewController.h
//  Goodnight
//
//  Created by Matt Zanchelli on 10/5/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	GNTimePickerModeSleep,
	GNTimePickerModeWake
} GNTimePickerMode;

@protocol GNTimePickerViewControllerDelegate <NSObject>

- (void)timePickerDidChangeToMode:(GNTimePickerMode)mode;
- (void)timePickerDidSayGoodnightWithSleepTime:(NSDate *)date
									   forMode:(GNTimePickerMode)mode;

@end

@interface GNTimePickerViewController : UIViewController

@property (nonatomic) id<GNTimePickerViewControllerDelegate> delegate;

@property (nonatomic) GNTimePickerMode mode;

/// Update the date picker to be the current time
- (void)updateDatePicker;

///
- (void)hideSun;

///
- (void)showSun;

@end
