//
//  GNTimePickerViewController.h
//  Goodnight
//
//  Created by Matt Zanchelli on 10/5/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSInteger, GNTimePickerMode) {
	GNTimePickerModeSleep,
	GNTimePickerModeWake
};

@protocol GNTimePickerViewControllerDelegate <NSObject>

- (void)timePickerDidChangeToMode:(GNTimePickerMode)mode;
- (void)timePickerDidSayGoodnightWithSleepTime:(NSDate *)date
									   forMode:(GNTimePickerMode)mode;

@end

@interface GNTimePickerViewController : UIViewController

@property (nonatomic) id<GNTimePickerViewControllerDelegate> delegate;

@property (nonatomic) GNTimePickerMode mode;

@property (strong, nonatomic) UIColor *tintColor;

/// The level at which the sun peaks out from behind the picker.
@property (nonatomic) CGFloat sunpeak;

/// Update the date picker to be the current time
- (void)updateDatePicker;

@end
