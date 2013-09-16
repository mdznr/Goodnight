//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GNViewController ()

#pragma mark Private Property

@property (strong, nonatomic) IBOutlet UIImageView *sky;
@property (strong, nonatomic) IBOutlet UIImageView *stars;

@property (strong, nonatomic) UIImage *darkSky;
@property (strong, nonatomic) UIImage *lightSky;

@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;

@property (strong, nonatomic) IBOutlet UIView *selectorView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *goodnightButton;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) UILabel *timeBad;
@property (strong, nonatomic) UILabel *timeFine;
@property (strong, nonatomic) UILabel *timeGood;
@property (strong, nonatomic) UILabel *timeGreat;

@end

#define ANIMATION_DURATION 0.2f

#define NUMBER_OF_CARDS 4

#define BAD_OPACITY   0.7f
#define FINE_OPACITY  0.8f
#define GOOD_OPACITY  0.9f
#define GREAT_OPACITY 1.0f

#define MODE_BUTTON_ACTIVE_OPACITY 1.0f
#define MODE_BUTTON_INACTIVE_OPACITY 0.4f

#define FALL_ASLEEP_TIME (14*60)
#define SLEEP_CYCLE_TIME (90*60)
#define BAD_SLEEP_TIME   (FALL_ASLEEP_TIME+(3*SLEEP_CYCLE_TIME))
#define FINE_SLEEP_TIME  (FALL_ASLEEP_TIME+(4*SLEEP_CYCLE_TIME))
#define GOOD_SLEEP_TIME  (FALL_ASLEEP_TIME+(5*SLEEP_CYCLE_TIME))
#define GREAT_SLEEP_TIME (FALL_ASLEEP_TIME+(6*SLEEP_CYCLE_TIME))

@implementation GNViewController


#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Setup background motion effects
	UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horizontal.minimumRelativeValue = @(20);
	horizontal.maximumRelativeValue = @(-20);
	UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	vertical.minimumRelativeValue = @(20);
	vertical.maximumRelativeValue = @(-20);
	_stars.motionEffects = @[horizontal, vertical];
	
	_lightSky = [UIImage imageNamed:@"lightSky"];
	_darkSky = [UIImage imageNamed:@"darkSky"];
	
	// Autoresize top and bottom views
	_selectorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	// Add targets to buttons for events
	[_sleepButton addTarget:self
					 action:@selector(tappedSleepButton:)
		   forControlEvents:UIControlEventTouchUpInside];
	[_wakeButton addTarget:self
					action:@selector(tappedWakeButton:)
		  forControlEvents:UIControlEventTouchUpInside];
	
	// Picker actions
	[_datePicker addTarget:self
					action:@selector(sleepPickerDidChange:)
		  forControlEvents:UIControlEventValueChanged];
	
	// Setup formatter
	_dateFormatter = [[NSDateFormatter alloc] init];
	_dateFormatter.dateFormat = @"h:mm a";
	
	// Setup times
#warning frames for times?
	_timeBad   = [[UILabel alloc] init];
	_timeFine  = [[UILabel alloc] init];
	_timeGood  = [[UILabel alloc] init];
	_timeGreat = [[UILabel alloc] init];
	
	// Update times
	[self updateTimes];
	
#warning store last used mode in preferences and use below
	[self setMode:GNViewControllerModeSetSleepTime];
}


#pragma mark IBActions

#warning able to tap two buttons near simultaneously
- (IBAction)tappedSleepButton:(id)sender
{
	[self setMode:GNViewControllerModeSetSleepTime];
	
	// Have to do this since UIDatePicker doesn't perform action for UIControlEventValueChanged when using setDate:Animated:
	[self updateTimes];
}

- (IBAction)tappedWakeButton:(id)sender
{
	[self setMode:GNViewControllerModeSetWakeTime];
	
	// Have to do this since UIDatePicker doesn't perform action for UIControlEventValueChanged when using setDate:Animated:
	[self updateTimes];
}


#pragma mark Modes

- (void)setMode:(GNViewControllerMode)mode
{
	_mode = mode;
	switch (mode) {
		case GNViewControllerModeSetSleepTime:
			[self sleepMode];
			break;
		case GNViewControllerModeSetWakeTime:
			[self wakeMode];
			break;
	}
}

- (void)sleepMode
{
#warning animate?
	_sleepButton.alpha = MODE_BUTTON_ACTIVE_OPACITY;
	_wakeButton.alpha  = MODE_BUTTON_INACTIVE_OPACITY;
	
#warning this should animate down
	_stars.hidden = NO;
	
	_sky.image = _darkSky;
	
	// Set purple tint color
	[_goodnightButton setTintColor:[UIColor colorWithRed:157.0f/255.0f
												   green: 75.0f/255.0f
													blue:212.0f/255.0f
												   alpha:1.0f]];
}

- (void)wakeMode
{
#warning animate?
	_wakeButton.alpha  = MODE_BUTTON_ACTIVE_OPACITY;
	_sleepButton.alpha = MODE_BUTTON_INACTIVE_OPACITY;
	
#warning this should animate up and out of opacity
	_stars.hidden = YES;
	
	_sky.image = _lightSky;
	
	// Set blue tint color
	[_goodnightButton setTintColor:[UIColor colorWithRed: 69.0f/255.0f
												   green:172.0f/255.0f
													blue:245.0f/255.0f
												   alpha:1.0f]];
}


#pragma mark Picker actions

- (void)sleepPickerDidChange:(id)sender
{
	[self updateTimes];
}

- (void)updateTimes
{
	NSDate *date = _datePicker.date;
	_timeBad.text   = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:BAD_SLEEP_TIME]];
	_timeFine.text  = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:FINE_SLEEP_TIME]];
	_timeGood.text  = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:GOOD_SLEEP_TIME]];
	_timeGreat.text = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:GREAT_SLEEP_TIME]];
}


- (void)wakePickerDidChange:(id)sender
{
	[self updateSleepCardTimes];
}

- (void)updateSleepCardTimes
{
	NSDate *date = _datePicker.date;
	_timeBad.text   = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:-BAD_SLEEP_TIME]];
	_timeFine.text  = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:-FINE_SLEEP_TIME]];
	_timeGood.text  = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:-GOOD_SLEEP_TIME]];
	_timeGreat.text = [_dateFormatter stringFromDate:[date dateByAddingTimeInterval:-GREAT_SLEEP_TIME]];
}


#pragma mark UIViewController Stuff

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}


@end
