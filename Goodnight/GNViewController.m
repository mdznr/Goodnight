//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GNInfoViewController.h"
#import "GNTimePickerViewController.h"
#import "GNTimesViewController.h"

@interface GNViewController () <GNTimePickerViewControllerDelegate, GNTimesViewControllerDelegate>

#pragma mark Private Property

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *sky;
@property (strong, nonatomic) IBOutlet UIImageView *stars;

@property (strong, nonatomic) GNTimesViewController *timesViewController;
@property (strong, nonatomic) GNTimePickerViewController *timePickerViewController;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UIView *info;

@property (strong, nonatomic) IBOutlet UILabel *instructions;

@property (nonatomic) BOOL hasUsedAppBefore;
@property (nonatomic) BOOL showingMainUI;

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
	_yChange = self.view.frame.size.height - 56 - 20;
	
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
	
	// Time Picker View Controller
	_timePickerViewController = [[GNTimePickerViewController alloc] init];
	_timePickerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_timePickerViewController.view.frame = self.view.frame;
	[_scrollView addSubview:_timePickerViewController.view];
	_timePickerViewController.delegate = self;
	
	// Times View Controller
	_timesViewController = [[GNTimesViewController alloc] init];
	_timesViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_timesViewController.view.frame = self.view.frame;
	_timesViewController.view.alpha = 0.0f;
	[_scrollView addSubview:_timesViewController.view];
	_timesViewController.delegate = self;
	
	// Add Info Button Action
	[_infoButton addTarget:self
					action:@selector(tappedInfoButton:)
		  forControlEvents:UIControlEventTouchUpInside];
	
#warning store last used mode in preferences and use below
	[self setSkyMode:GNSkyModeDusk];
	
	_showingMainUI = YES;
	
#warning see if the app has been used
	_hasUsedAppBefore = NO;
	if ( !_hasUsedAppBefore && _showingMainUI ) {
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


#pragma mark Time Picker View Controller Delegate

- (void)timePickerDidChangeToMode:(GNTimePickerMode)mode
{
	switch ( mode ) {
		case GNTimePickerModeSleep: {
//			_timesViewController.mode = GNTimesViewControllerModeWakeTimes;
			[self animateToDusk];
		} break;
		case GNTimePickerModeWake: {
//			_timesViewController.mode = GNTimesViewControllerModeSleepTimes;
			[self animateToDawn];
		} break;
	}
	
	// Only manipulate instructions if necessary
	if ( !_hasUsedAppBefore && _showingMainUI ) {
		[self fadeInstructionsOut];
	}
}

- (void)timePickerDidSayGoodnightWithSleepTime:(NSDate *)date
									   forMode:(GNTimePickerMode)mode
{
	_showingMainUI = NO;
	_timesViewController.date = date;
	
	[_timePickerViewController hideSun];
	
	switch ( mode ) {
		case GNTimePickerModeSleep: {
			_timesViewController.mode = GNTimesViewControllerModeWakeTimes;
			[self animateToDawn];
		} break;
		case GNTimePickerModeWake: {
			_timesViewController.mode = GNTimesViewControllerModeSleepTimes;
			[self animateToDusk];
		} break;
	}
	
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
						 _infoButton.frame = CGRectOffset(_infoButton.frame, 0, _yChange);
						 _timePickerViewController.view.frame = CGRectOffset(_timePickerViewController.view.frame, 0, _yChange);
					 }
					 completion:^(BOOL finished) {}];
	
	// Show Times View Controller
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _timesViewController.view.alpha = 1.0f;
						 [_timesViewController animateIn];
					 }
					 completion:^(BOOL finished) {}];
}


#pragma mark Times View Controller Delegate

- (void)timesViewControllerRequestsDismissal
{
	switch ( _timesViewController.mode ) {
		case GNTimesViewControllerModeSleepTimes:
			[self animateToDawn];
			break;
		case GNTimesViewControllerModeWakeTimes:
		default:
			[self animateToDusk];
			break;
	}
	
	_showingMainUI = YES;
	
	[_timePickerViewController showSun];
	
	// Make sure it's at alpha 0.0f?
	_instructions.alpha = 0.0f;
	_instructions.hidden = NO;
	
	// Only show instructions if necessary
	if ( !_hasUsedAppBefore && _showingMainUI ) {
		[self fadeInstructionsOut];
	}
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _timesViewController.view.alpha = 0.0f;
						 [_timesViewController animateOut];
					 }
					 completion:^(BOOL finished) {
						 if ( !_hasUsedAppBefore && _showingMainUI ) {
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
						 
						 _infoButton.frame = CGRectOffset(_infoButton.frame, 0, -_yChange);
						 _timePickerViewController.view.frame = CGRectOffset(_timePickerViewController.view.frame, 0, -_yChange);
					 }
					 completion:^(BOOL finished) { }];
}

- (void)timesViewControllerSetSleepReminderForTime:(NSDate *)time
{
	
}

- (void)timesViewControllerSetWakeAlarmForTime:(NSDate *)time
{
	
}


#pragma mark Button Actions

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
	
	if ( _showingMainUI ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
//							 _stars.alpha = 0.33f;
							 _timePickerViewController.view.frame = CGRectOffset(_timePickerViewController.view.frame, 0, _yChange);
						 }
						 completion:^(BOOL finished) {}];
	} else {
		// Animate times out
		[_timesViewController animateOut];
	}
	
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
						 [UIView animateWithDuration:ANIMATION_DURATION
											   delay:0.0f
							  usingSpringWithDamping:1.0f
							   initialSpringVelocity:1.0f
											 options:UIViewAnimationOptionBeginFromCurrentState
										  animations:^{
						 } completion:^(BOOL finished) {}];
						 
						 if ( !_hasUsedAppBefore && _showingMainUI ) {
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
	
	if ( _showingMainUI ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 _timePickerViewController.view.frame = CGRectOffset(_timePickerViewController.view.frame, 0, -_yChange);
						 }
						 completion:^(BOOL finished) { }];
	} else {
		[_timesViewController animateIn];
	}
}


#pragma mark Modes

- (void)setSkyMode:(GNSkyMode)skyMode
{
	switch ( skyMode ) {
		case GNSkyModeDawn: {
			[self animateToDawn];
		} break;
		case GNSkyModeDusk: {
			[self animateToDusk];
		} break;
	}
}

- (void)animateToDusk
{
	// Show stars
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _stars.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	// Animate sky
	// Bring up dusk
	// Change time picker tint color
	[UIView animateWithDuration:ANIMATION_DURATION * 3
						  delay:0.0f
		 usingSpringWithDamping:10.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 CGPoint skyStart = (CGPoint){self.view.frame.size.width/2, -20+(_sky.image.size.height/2)};
						 _sky.center = skyStart;
						 
						 UIColor *color = [UIColor colorWithRed:157.0f/255.0f
														  green: 75.0f/255.0f
														   blue:212.0f/255.0f
														  alpha:1.0f];
						 _timePickerViewController.view.tintColor = color;
					 }
					 completion:^(BOOL finished) { }];
}

- (void)animateToDawn
{
	// Dim Stars
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _stars.alpha = 0.2f;
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
						 
						 UIColor *color = [UIColor colorWithRed: 69.0f/255.0f
														  green:172.0f/255.0f
														   blue:245.0f/255.0f
														  alpha:1.0f];
						 [_timePickerViewController.view setTintColor:color];
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
	switch ( _timePickerViewController.mode ) {
		case GNTimePickerModeSleep:
#warning get localized string
			_instructions.text = @"Set the time you’d\nlike to fall asleep at";
			break;
		case GNTimePickerModeWake:
#warning get localized string
			_instructions.text = @"Set the time you’d\nlike to wake up at";
			break;
	}
	
	[UIView animateWithDuration:ANIMATION_DURATION * 2
						  delay:ANIMATION_DURATION
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _instructions.alpha = 0.75f;
					 }
					 completion:^(BOOL finished) {}];
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
