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
#import "GNInfoViewController.h"
#import "GNTimesViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GNViewController ()

#pragma mark Private Property

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *sky;
@property (strong, nonatomic) IBOutlet UIImageView *stars;
@property (strong, nonatomic) IBOutlet UIImageView *dusk;
@property (strong, nonatomic) IBOutlet UIImageView *sunrise;

@property (strong, nonatomic) GNTimesViewController *timesViewController;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UIView *info;

@property (strong, nonatomic) IBOutlet UIButton *dismissButton;

@property (strong, nonatomic) IBOutlet UILabel *instructions;

@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;

@property (strong, nonatomic) IBOutlet MTZTriangleView *triangleMarker;

@property (strong, nonatomic) IBOutlet UIView *selectorView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet MTZOutlinedButton *goodnightButton;

@property (nonatomic) BOOL hasUsedAppBefore;

@property (strong, nonatomic) NSDate *dateToResumeAnimatingInstructions;

@property (nonatomic) CGFloat yChange;

@end

#define ANIMATION_DURATION 0.75f

@implementation GNViewController


#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Find necessary y change to hide main UI
	_yChange = self.view.frame.size.height - _wakeButton.frame.origin.y;
	
	// Make sure sky imageView is tall enough
	_sky.frame = (CGRect){_sky.frame.origin.x, _sky.frame.origin.y, _sky.image.size.width, _sky.image.size.height};
	
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
	
	_timesViewController = [[GNTimesViewController alloc] init];
	// Expand VC to fill current view
	_timesViewController.view.frame = self.view.frame;
	_timesViewController.view.alpha = 0.0f;
	[_scrollView insertSubview:_timesViewController.view
				  belowSubview:_dismissButton];
	
	// Add goodnight button action
	[_goodnightButton addTarget:self
						 action:@selector(tappedGoodnightButton:)
			   forControlEvents:UIControlEventTouchUpInside];
	
	// Add Info button action
	[_infoButton addTarget:self
					action:@selector(tappedInfoButton:)
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
	
#warning store last used mode in preferences and use below
	[self setMode:GNViewControllerModeSetSleepTime];
	
#warning see if the app has been used
	_hasUsedAppBefore = NO;
	if ( !_hasUsedAppBefore ) {
		[UIView animateWithDuration:2 * ANIMATION_DURATION
							  delay:2 * ANIMATION_DURATION
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 _instructions.alpha = 0.7;
						 }
						 completion:^(BOOL finished) {}];
	}
	
	// Setup instructions
	_info = [[GNInfoViewController alloc] initWithNibName:@"GNInfoViewController"
													 bundle:nil].view;
	_info.alpha = 0.0f;
	[_scrollView insertSubview:_info belowSubview:_infoButton];
}


#pragma mark Button Actions

#warning able to tap two buttons near simultaneously
- (IBAction)tappedSleepButton:(id)sender
{
	[self setMode:GNViewControllerModeSetSleepTime];
}

- (IBAction)tappedWakeButton:(id)sender
{
	[self setMode:GNViewControllerModeSetWakeTime];
}

- (void)tappedGoodnightButton:(id)sender
{
	switch (self.mode) {
		case GNViewControllerModeSetWakeTime:
			_timesViewController.mode = GNTimesViewControllerModeSleepTimes;
			[self sleepMode];
			break;
		case GNViewControllerModeSetSleepTime:
		default:
			_timesViewController.mode = GNTimesViewControllerModeWakeTimes;
			[self wakeMode];
			break;
	}
	
	_timesViewController.date = _datePicker.date;
	
	// Hide instructional text
	[UIView animateWithDuration:ANIMATION_DURATION/2
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _instructions.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _instructions.hidden = YES;
					 }];
	
	// Move the main UI away
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
//						 _stars.alpha = 0.33f;
						 
#warning instructions will still display in visible frame
						 _instructions.frame = CGRectOffset(_instructions.frame, 0, _yChange);
						 _sleepButton.frame = CGRectOffset(_sleepButton.frame, 0, _yChange);
						 _wakeButton.frame = CGRectOffset(_wakeButton.frame, 0, _yChange);
						 _triangleMarker.frame = CGRectOffset(_triangleMarker.frame, 0, _yChange);
						 _selectorView.frame = CGRectOffset(_selectorView.frame, 0, _yChange);
						 _dusk.frame = CGRectOffset(_dusk.frame, 0, _yChange);
						 _sunrise.frame = CGRectOffset(_sunrise.frame, 0, _yChange);
					 }
					 completion:^(BOOL finished) {}];
	
	// Show Times View Controller
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _timesViewController.view.alpha = 1.0f;
						 [_timesViewController animateIn];
						 _dismissButton.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (IBAction)dismissButtonTapped:(id)sender
{
	switch (_timesViewController.mode) {
		case GNTimesViewControllerModeSleepTimes:
			[self wakeMode];
			break;
		case GNTimesViewControllerModeWakeTimes:
		default:
			[self sleepMode];
			break;
	}
	
	// Make sure it's at alpha 0.0f?
	_instructions.alpha = 0.0f;
	_instructions.hidden = NO;
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _timesViewController.view.alpha = 0.0f;
						 [_timesViewController animateOut];
						 _dismissButton.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 if ( !_hasUsedAppBefore ) {
							 [UIView animateWithDuration:ANIMATION_DURATION*2
												   delay:0.0f
								  usingSpringWithDamping:1.0f
								   initialSpringVelocity:1.0f
												 options:UIViewAnimationOptionBeginFromCurrentState
											  animations:^{
												  _instructions.alpha = 0.7f;
											  }
											  completion:^(BOOL finished) {}];
						 }
					 }];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
//						 _stars.alpha = 1.0f;
						 
						 _sleepButton.frame = CGRectOffset(_sleepButton.frame, 0, -_yChange);
						 _wakeButton.frame = CGRectOffset(_wakeButton.frame, 0, -_yChange);
						 _triangleMarker.frame = CGRectOffset(_triangleMarker.frame, 0, -_yChange);
						 _selectorView.frame = CGRectOffset(_selectorView.frame, 0, -_yChange);
						 _dusk.frame = CGRectOffset(_dusk.frame, 0, -_yChange);
						 _sunrise.frame = CGRectOffset(_sunrise.frame, 0, -_yChange);
					 }
					 completion:^(BOOL finished) { }];
}

- (void)tappedInfoButton:(id)sender
{
	_infoButton.selected = !_infoButton.selected;
	
	if ( _infoButton.selected ) {
		[self showInfo];
	} else {
		[self hideInfo];
	}
}

- (void)showInfo
{
	[UIView animateWithDuration:ANIMATION_DURATION/2
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _instructions.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _instructions.hidden = YES;
					 }];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
//						 _stars.alpha = 0.33f;
						 
						 _sleepButton.frame = CGRectOffset(_sleepButton.frame, 0, _yChange);
						 _wakeButton.frame = CGRectOffset(_wakeButton.frame, 0, _yChange);
						 _triangleMarker.frame = CGRectOffset(_triangleMarker.frame, 0, _yChange);
						 _selectorView.frame = CGRectOffset(_selectorView.frame, 0, _yChange);
						 _dusk.frame = CGRectOffset(_dusk.frame, 0, _yChange);
						 _sunrise.frame = CGRectOffset(_sunrise.frame, 0, _yChange);
					 }
					 completion:^(BOOL finished) {}];
	
	// Show Info text
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _info.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)hideInfo
{
	// make sure it's at alpha 0.0f?
	_instructions.alpha = 0.0f;
	_instructions.hidden = NO;
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _info.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 if ( !_hasUsedAppBefore ) {
							 [UIView animateWithDuration:ANIMATION_DURATION*2
												   delay:0.0f
								  usingSpringWithDamping:1.0f
								   initialSpringVelocity:1.0f
												 options:UIViewAnimationOptionBeginFromCurrentState
											  animations:^{
												  _instructions.alpha = 0.7f;
											  }
											  completion:^(BOOL finished) {}];
						 }
					 }];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
//						 _stars.alpha = 1.0f;
						 
						 _sleepButton.frame = CGRectOffset(_sleepButton.frame, 0, -_yChange);
						 _wakeButton.frame = CGRectOffset(_wakeButton.frame, 0, -_yChange);
						 _triangleMarker.frame = CGRectOffset(_triangleMarker.frame, 0, -_yChange);
						 _selectorView.frame = CGRectOffset(_selectorView.frame, 0, -_yChange);
						 _dusk.frame = CGRectOffset(_dusk.frame, 0, -_yChange);
						 _sunrise.frame = CGRectOffset(_sunrise.frame, 0, -_yChange);
					 }
					 completion:^(BOOL finished) { }];
}


#pragma mark Modes

- (void)setMode:(GNViewControllerMode)mode
{
	// Only manipulate instructions if necessary
	if ( _mode != mode && !_hasUsedAppBefore ) {
		[self fadeInstructionsOut];
	}
	
	_mode = mode;
	switch (mode) {
		case GNViewControllerModeSetSleepTime: {
			[self sleepMode];
			[UIView animateWithDuration:ANIMATION_DURATION
								  delay:0.0f
				 usingSpringWithDamping:1.0f
				  initialSpringVelocity:1.0f
								options:UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
#warning UIButton does not animate between selected states
								 _wakeButton.selected = NO;
								 _sleepButton.selected = YES;
								 
								 _triangleMarker.center = (CGPoint){_sleepButton.center.x, _triangleMarker.center.y};
							 }
							 completion:^(BOOL finished) {}];
		} break;
		case GNViewControllerModeSetWakeTime: {
			[self wakeMode];
			[UIView animateWithDuration:ANIMATION_DURATION
								  delay:0.0f
				 usingSpringWithDamping:1.0f
				  initialSpringVelocity:1.0f
								options:UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
#warning UIButton does not animate between selected states
								 _wakeButton.selected = YES;
								 _sleepButton.selected = NO;
								 
								 _triangleMarker.center = (CGPoint){_wakeButton.center.x, _triangleMarker.center.y};
							 }
							 completion:^(BOOL finished) {}];
		} break;
	}
		
}

- (void)sleepMode
{
	// Select Sleep segmented control button
	// Hide sunrise
	// Bring in stars
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _sunrise.alpha = 0.0f; // Animate down, too
						 
						 _stars.center = (CGPoint){_stars.center.x, _stars.center.y + 50.0f};
						 _stars.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	// Animate sky
	// Bring up dusk
	// Change goodnight button tint color
	[UIView animateWithDuration:ANIMATION_DURATION * 3
						  delay:0.0f
		 usingSpringWithDamping:10.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 CGPoint skyStart = (CGPoint){self.view.frame.size.width/2, -20+(_sky.image.size.height/2)};
						 _sky.center = skyStart;
						 _dusk.alpha = 1.0f;	// Animate up, too
						 
						 UIColor *color = [UIColor colorWithRed:157.0f/255.0f
														  green: 75.0f/255.0f
														   blue:212.0f/255.0f
														  alpha:1.0f];
						 [_goodnightButton setTintColor:color];
					 }
					 completion:^(BOOL finished) { }];
}

- (void)wakeMode
{
	// Select Sleep segmented control button
	// Hide sunrise
	// Bring in stars
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _dusk.alpha = 0.0f;	// Animate down, too
						 
						 _stars.center = (CGPoint){_stars.center.x, _stars.center.y - 50.0f};
						 _stars.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	// Animate sky
	// Bring up dusk
	// Change goodnight button tint color
	[UIView animateWithDuration:ANIMATION_DURATION * 3
						  delay:0.0f
		 usingSpringWithDamping:10.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 CGPoint skyEnd = (CGPoint){self.view.frame.size.width/2, 20+self.view.bounds.size.height-(_sky.image.size.height/2)};
						 _sky.center = skyEnd;
						 _sunrise.alpha = 0.5f; // Animate up, too
						 
						 UIColor *color = [UIColor colorWithRed: 69.0f/255.0f
														  green:172.0f/255.0f
														   blue:245.0f/255.0f
														  alpha:1.0f];
						 [_goodnightButton setTintColor:color];
					 }
					 completion:^(BOOL finished) { }];
}

- (void)fadeInstructionsOut
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self
											 selector:@selector(fadeInstructionsIn)
											   object:nil];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _instructions.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	[self performSelector:@selector(fadeInstructionsIn) withObject:nil afterDelay:ANIMATION_DURATION];
}

- (void)fadeInstructionsIn
{
	#warning get localized string
	if ( _mode == GNViewControllerModeSetWakeTime ) {
		_instructions.text = @"Set the time you’d\nlike to wake up at";
	} else {
		_instructions.text = @"Set the time you’d\nlike to fall asleep at";
	}
	
	[UIView animateWithDuration:2 * ANIMATION_DURATION
						  delay:2 * ANIMATION_DURATION
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _instructions.alpha = 0.75f;
					 }
					 completion:^(BOOL finished) {}];
}


#pragma mark Picker actions

- (void)sleepPickerDidChange:(id)sender
{
	
}


- (void)wakePickerDidChange:(id)sender
{

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
