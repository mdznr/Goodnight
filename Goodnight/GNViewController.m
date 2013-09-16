//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNViewController.h"
#import "MTZOutlinedButton.h"
#import "MTZTriangleView.h"
#import <QuartzCore/QuartzCore.h>

@interface GNViewController ()

#pragma mark Private Property

@property (strong, nonatomic) IBOutlet UIImageView *sky;
@property (strong, nonatomic) IBOutlet UIImageView *stars;
@property (strong, nonatomic) IBOutlet UIImageView *dusk;
@property (strong, nonatomic) IBOutlet UIImageView *sunrise;

@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;

@property (strong, nonatomic) IBOutlet MTZTriangleView *triangleMarker;

@property (strong, nonatomic) IBOutlet UIView *selectorView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet MTZOutlinedButton *goodnightButtonSleep;
@property (strong, nonatomic) IBOutlet MTZOutlinedButton *goodnightButtonWake;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) UILabel *timeBad;
@property (strong, nonatomic) UILabel *timeFine;
@property (strong, nonatomic) UILabel *timeGood;
@property (strong, nonatomic) UILabel *timeGreat;

@end

#define ANIMATION_DURATION 0.75f

#define NUMBER_OF_CARDS 4

#define BAD_OPACITY   0.7f
#define FINE_OPACITY  0.8f
#define GOOD_OPACITY  0.9f
#define GREAT_OPACITY 1.0f

#define FALL_ASLEEP_TIME (14*60)
#define SLEEP_CYCLE_TIME (90*60)
#define BAD_SLEEP_TIME   (FALL_ASLEEP_TIME+(3*SLEEP_CYCLE_TIME))
#define FINE_SLEEP_TIME  (FALL_ASLEEP_TIME+(4*SLEEP_CYCLE_TIME))
#define GOOD_SLEEP_TIME  (FALL_ASLEEP_TIME+(5*SLEEP_CYCLE_TIME))
#define GREAT_SLEEP_TIME (FALL_ASLEEP_TIME+(6*SLEEP_CYCLE_TIME))

@implementation GNViewController
{
	CGPoint skyStart;
	CGPoint skyEnd;
}


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
	_sunrise.motionEffects = @[vertical];
	_dusk.motionEffects = @[vertical];
	
	[_goodnightButtonSleep setTintColor:[UIColor colorWithRed:157.0f/255.0f
														green: 75.0f/255.0f
														 blue:212.0f/255.0f
														alpha:1.0f]];
	
	[_goodnightButtonWake setTintColor:[UIColor colorWithRed: 69.0f/255.0f
													   green:172.0f/255.0f
														blue:245.0f/255.0f
													   alpha:1.0f]];
	// Add goodnight button action
	[_goodnightButtonSleep addTarget:self
							  action:@selector(tappedGoodnightButton:)
					forControlEvents:UIControlEventTouchUpInside];
	[_goodnightButtonWake addTarget:self
							 action:@selector(tappedGoodnightButton:)
				   forControlEvents:UIControlEventTouchUpInside];
	
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
	
	// Calculate start and end frames from dusk and dawn
	skyStart = (CGPoint){self.view.frame.size.width/2, -20+(_sky.image.size.height/2)};
	skyEnd = (CGPoint){self.view.frame.size.width/2, 20+_selectorView.frame.origin.y-(_sky.image.size.height/2)};
}


#pragma mark Button Actions

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

- (void)tappedGoodnightButton:(id)sender
{
#warning animate and show times
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
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
#warning UIButton does not animate between selected states
						 _sleepButton.selected = YES;
						 _wakeButton.selected = NO;
						 
						 _sunrise.alpha = 0.0f; // Animate down, too
						 
						 _stars.center = (CGPoint){_stars.center.x, _stars.center.y + 50.0f};
						 _stars.alpha = 1.0f;
						 
						 _triangleMarker.center = (CGPoint){_sleepButton.center.x, _triangleMarker.center.y};
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION * 3
						  delay:0.0f
		 usingSpringWithDamping:10.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _sky.center = skyStart;
						 _dusk.alpha = 1.0f;	// Animate up, too
						 
						 _goodnightButtonSleep.alpha = 1.0f;
						 _goodnightButtonWake.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) { }];
}

- (void)wakeMode
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
#warning UIButton does not animate between selected states
						 _wakeButton.selected = YES;
						 _sleepButton.selected = NO;
						 
						 _dusk.alpha = 0.0f;	// Animate down, too
						 
						 _stars.center = (CGPoint){_stars.center.x, _stars.center.y - 50.0f};
						 _stars.alpha = 0.0f;
						 
						 _triangleMarker.center = (CGPoint){_wakeButton.center.x, _triangleMarker.center.y};
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION * 3
						  delay:0.0f
		 usingSpringWithDamping:10.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _sky.center = skyEnd;
						 _sunrise.alpha = 0.5f; // Animate up, too
						 
						 _goodnightButtonWake.alpha = 1.0f;
						 _goodnightButtonSleep.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) { }];
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
