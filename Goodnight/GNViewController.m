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

@interface GNViewController () <UIScrollViewDelegate, GNTimePickerViewControllerDelegate, GNTimesViewControllerDelegate>

#pragma mark Private Property

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *sky;
@property (strong, nonatomic) IBOutlet UIImageView *stars;

@property (strong, nonatomic) GNTimesViewController *timesViewController;
@property (strong, nonatomic) GNTimePickerViewController *timePickerViewController;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UIView *info;

@property (strong, nonatomic) IBOutlet UIView *instructionsView;
@property (strong, nonatomic) IBOutlet UILabel *instructions;

@property (nonatomic) BOOL hasUsedAppBefore;
@property (nonatomic) BOOL showingMainUI;

@end

#define ANIMATION_DURATION 0.85f

@implementation GNViewController

#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
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
	
	_scrollView.contentSize = (CGSize){self.view.frame.size.width, self.view.frame.size.height * 2};
	_scrollView.contentOffset = (CGPoint){0,self.view.frame.size.height};
	
	// Move instructions down to second (bottom) page
	_instructionsView.frame = CGRectOffset(_instructionsView.frame, 0, _scrollView.frame.size.height);
	_instructions.alpha = 0.0f;
	
	// Time Picker View Controller
	_timePickerViewController = [[GNTimePickerViewController alloc] initWithNibName:@"GNTimePickerViewController" bundle:nil];
	_timePickerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_timePickerViewController.view.frame = CGRectOffset(self.view.frame, 0, self.view.frame.size.height);
	[_scrollView insertSubview:_timePickerViewController.view
				  belowSubview:_instructionsView];
	_timePickerViewController.delegate = self;
	
	// Times View Controller
	_timesViewController = [[GNTimesViewController alloc] init];
	_timesViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_timesViewController.view.frame = self.view.frame;
	_timesViewController.view.alpha = 0.0f;
	[_scrollView insertSubview:_timesViewController.view
				  belowSubview:_infoButton];
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
	[self fadeInstructionsOut];
	
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
			_timesViewController.mode = GNTimesViewControllerModeWakeTimes;
			[self animateToDusk];
		} break;
		case GNTimePickerModeWake: {
			_timesViewController.mode = GNTimesViewControllerModeSleepTimes;
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
	switch ( mode ) {
		case GNTimePickerModeSleep: {
			_timesViewController.mode = GNTimesViewControllerModeWakeTimes;
		} break;
		case GNTimePickerModeWake: {
			_timesViewController.mode = GNTimesViewControllerModeSleepTimes;
		} break;
	}
	
	_timesViewController.date = date;
	
	// Show Times View Controller
	[_timesViewController performSelector:@selector(animateIn) withObject:Nil afterDelay:ANIMATION_DURATION/2];
	
	// Scroll up
//	[_scrollView scrollRectToVisible:(CGRect){0,0,1,1} animated:YES];
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _scrollView.contentOffset = CGPointZero;
					 }
					 completion:^(BOOL finished) {
						 [self topMode];
					 }];
}


#pragma mark Times View Controller Delegate

- (void)timesViewControllerRequestsDismissal
{
	// Hide Times View Controller
	[_timesViewController animateOut];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _scrollView.contentOffset = (CGPoint){0,_scrollView.frame.size.height};
					 }
					 completion:^(BOOL finished) {
						 [self bottomMode];
					 }];
	
}

- (void)timesViewControllerDidSetAlarm:(NSDate *)alarmTime
{
	_scrollView.scrollEnabled = NO;
	[self animateToDusk];
}

- (void)timesViewControllerDidSetSleepReminder:(NSDate *)reminderTime forWakeUpTime:(NSDate *)wakeTime;
{
	_scrollView.scrollEnabled = NO;
	[self animateToDusk];
}

- (void)timesViewControllerDidCancelAlarm
{
	switch ( _timesViewController.mode ) {
		case GNTimesViewControllerModeSleepTimes:
			[self animateToDusk];
			break;
		case GNTimesViewControllerModeWakeTimes:
			[self animateToDawn];
			break;
	}
	
	_scrollView.scrollEnabled = YES;
}

- (void)timesViewControllerDidCancelSleepReminder
{
	switch ( _timesViewController.mode ) {
		case GNTimesViewControllerModeSleepTimes:
			[self animateToDusk];
			break;
		case GNTimesViewControllerModeWakeTimes:
			[self animateToDawn];
			break;
	}
	
	_scrollView.scrollEnabled = YES;
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat scrollOffset = _scrollView.contentOffset.y;
	CGFloat scrollTotal = _scrollView.contentSize.height - _scrollView.frame.size.height;
	CGFloat scrollFraction = scrollOffset / scrollTotal;
	
	// y = -1.5|x-1|+1
	_instructionsView.alpha = (-1.5 * ABS(scrollFraction-1) + 1);
	
	CGFloat duskR = 157.0f/255.0f;
	CGFloat duskG = 75.0f/255.0f;
	CGFloat duskB = 212.0f/255.0f;
	
	CGFloat dawnR = 69.0f/255.0f;
	CGFloat dawnG = 172.0f/255.0f;
	CGFloat dawnB = 245.0f/255.0f;
	
	CGFloat r,g,b;
	
	CGFloat skyStart = -20 + (_sky.image.size.height/2);
	CGFloat skyEnd = 20 + _scrollView.frame.size.height - (_sky.image.size.height/2);
	CGFloat midSkyWidth = _sky.image.size.width / 2;
	CGFloat yOffset;
	CGFloat colorWeight = MIN(MAX(0,scrollFraction),1);
	switch ( _timePickerViewController.mode ) {
		case GNTimePickerModeSleep: {
			// Dusk
			yOffset = (scrollFraction * skyStart) + ((1-scrollFraction) * skyEnd);
			_stars.alpha = scrollFraction * 1.0f;
			
			r = (colorWeight * duskR) + ((1-colorWeight) * dawnR);
			g = (colorWeight * duskG) + ((1-colorWeight) * dawnG);
			b = (colorWeight * duskB) + ((1-colorWeight) * dawnB);
		} break;
		case GNTimePickerModeWake: {
			// Dawn
			yOffset = (scrollFraction * skyEnd) + ((1-scrollFraction) * skyStart);
			_stars.alpha = scrollFraction * 0.2f;
			
			r = (colorWeight * dawnR) + ((1-colorWeight) * duskR);
			g = (colorWeight * dawnG) + ((1-colorWeight) * duskG);
			b = (colorWeight * dawnB) + ((1-colorWeight) * duskB);
		} break;
	}
	yOffset = MAX(MIN(skyStart, yOffset), skyEnd);
	_sky.center = (CGPoint){midSkyWidth, yOffset};
	_timePickerViewController.tintColor = [UIColor colorWithRed:r
														  green:g
														   blue:b
														  alpha:1.0f];
	
	_timePickerViewController.sunpeak = scrollFraction;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ( scrollView.contentOffset.y >= scrollView.frame.size.height ) {
		[self bottomMode];
	} else {
		[self topMode];
	}
}

- (void)topMode
{
	_scrollView.scrollEnabled = YES;
	
	_showingMainUI = NO;
	
	_instructionsView.alpha = 0.0f;
	_instructions.alpha = 0.f;
}

- (void)bottomMode
{
	// Do not allow scrolling when showing picker.
	_scrollView.scrollEnabled = NO;
	
	_showingMainUI = YES;
	
	_instructionsView.alpha = 1.0f;
	
	// Only show instructions if necessary
	if ( !_hasUsedAppBefore) {
		[self fadeInstructionsOut];
	}
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
	if ( _showingMainUI ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 _scrollView.contentOffset = (CGPoint){0, self.view.frame.size.height};
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
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _info.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	if ( _showingMainUI ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 _scrollView.contentOffset = CGPointZero;
						 }
						 completion:^(BOOL finished) {}];
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
	// Animate sky
	// Bring up dusk
	// Change time picker tint color
	[UIView animateWithDuration:ANIMATION_DURATION * 2
						  delay:0.0f
		 usingSpringWithDamping:10.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 CGFloat skyStart = -20 + (_sky.image.size.height/2);
						 _sky.center = (CGPoint){_sky.image.size.width/2, skyStart};
						 
						 UIColor *color = [UIColor colorWithRed:157.0f/255.0f
														  green: 75.0f/255.0f
														   blue:212.0f/255.0f
														  alpha:1.0f];
						 _timePickerViewController.tintColor = color;

						 _stars.alpha = 0.7f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)animateToDawn
{
	// Dim Stars
	// Animate sky
	// Bring up dusk
	// Change goodnight button tint color
	[UIView animateWithDuration:ANIMATION_DURATION * 2
						  delay:0.0f
		 usingSpringWithDamping:10.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 CGFloat skyEnd = 20 + _scrollView.frame.size.height - (_sky.image.size.height/2);
						 _sky.center = (CGPoint){_sky.image.size.width/2, skyEnd};
						 
						 UIColor *color = [UIColor colorWithRed: 69.0f/255.0f
														  green:172.0f/255.0f
														   blue:245.0f/255.0f
														  alpha:1.0f];
						 _timePickerViewController.tintColor = color;
						 
						 _stars.alpha = 0.1f;
					 }
					 completion:^(BOOL finished) {}];
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
			_instructions.text = @"Set the time you’d\nlike to fall asleep";
			break;
		case GNTimePickerModeWake:
			_instructions.text = @"Set the time you’d\nlike to wake up";
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
