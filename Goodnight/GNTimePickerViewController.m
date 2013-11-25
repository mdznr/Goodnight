//
//  GNTimePickerViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 10/5/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "GNTimePickerViewController.h"

#import "NSDate+Rounding.h"
#import "MTZOutlinedButton.h"
#import "MTZTriangleView.h"

@interface GNTimePickerViewController ()

@property (strong, nonatomic) IBOutlet UIView *sunpeakView;
@property (strong, nonatomic) IBOutlet UIImageView *dusk;
@property (strong, nonatomic) IBOutlet UIImageView *sunrise;

@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;

@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *defaultColor;

@property (strong, nonatomic) IBOutlet MTZTriangleView *triangleMarker;

@property (strong, nonatomic) IBOutlet UIView *selectorView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet MTZOutlinedButton *goodnightButton;

@end

#define ANIMATION_DURATION 0.75f

#define WAKE_MODE_DATE_PICKER_MINUTE_INTERVAL 5
#define SLEEP_MODE_DATE_PICKER_MINUTE_INTERVAL 5

@implementation GNTimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Setup background motion effects
	UIInterpolatingMotionEffect *horizontal =
		[[UIInterpolatingMotionEffect alloc]
		 	initWithKeyPath:@"center.x"
					   type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horizontal.minimumRelativeValue = @(20);
	horizontal.maximumRelativeValue = @(-20);
	UIInterpolatingMotionEffect *vertical =
		[[UIInterpolatingMotionEffect alloc]
		 	initWithKeyPath:@"center.y"
		               type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	vertical.minimumRelativeValue = @(20);
	vertical.maximumRelativeValue = @(-20);
	
	_sunrise.motionEffects = @[vertical];
	_dusk.motionEffects = @[vertical];
	
	// Add goodnight button action
	[_goodnightButton addTarget:self
						 action:@selector(tappedGoodnightButton:)
			   forControlEvents:UIControlEventTouchUpInside];

	
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
	
	[self setMode:GNTimePickerModeSleep];
	_mode = GNTimePickerModeSleep;
	
	_defaultColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
	_selectedColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
	
	// Sleep button is selected by default
	[_sleepButton setTitleColor:_selectedColor forState:UIControlStateNormal];
}


#pragma mark Button Actions

- (void)tappedSleepButton:(id)sender
{
	[self setMode:GNTimePickerModeSleep];
}

- (void)tappedWakeButton:(id)sender
{
	[self setMode:GNTimePickerModeWake];
}

- (void)tappedGoodnightButton:(id)sender
{
	[_delegate timePickerDidSayGoodnightWithSleepTime:_datePicker.date
											  forMode:_mode];
}


#pragma mark Sun

- (void)setSunpeak:(CGFloat)sunpeak
{
	_sunpeak = sunpeak;
	_sunpeakView.alpha = sunpeak;
	_sunpeakView.frame = (CGRect){_sunpeakView.frame.origin.x,
								  (_sunpeakView.frame.size.height * MIN(MAX(0,ABS(1-sunpeak)),1)) - 20,
		                          _sunpeakView.frame.size.width,
		                          _sunpeakView.frame.size.height};
}


#pragma mark Mode

- (void)setMode:(GNTimePickerMode)mode
{
	switch ( mode ) {
		case GNTimePickerModeSleep: {
			[self sleepMode];
		} break;
		case GNTimePickerModeWake: {
			[self wakeMode];
		} break;
	}
	
	if ( _mode != mode ) {
		_mode = mode;
		[_delegate timePickerDidChangeToMode:mode];
	}
}

- (void)sleepMode
{
	_datePicker.minuteInterval = SLEEP_MODE_DATE_PICKER_MINUTE_INTERVAL;
	if ( self.mode != GNTimePickerModeSleep ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
#warning UIButton does not animate between selected states
							 [_sleepButton setTitleColor:_selectedColor
												forState:UIControlStateNormal];
							 [_wakeButton setTitleColor:_defaultColor
											   forState:UIControlStateNormal];
							 
							 _sunrise.alpha = 0.0f;
							 
							 _triangleMarker.center = (CGPoint){_sleepButton.center.x, _triangleMarker.center.y};
						 }
						 completion:^(BOOL finished) {}];
		
		[UIView animateWithDuration:ANIMATION_DURATION *3
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 _dusk.alpha = 1.0f;
						 }
						 completion:^(BOOL finished) {}];
	} else {
		[_datePicker setDate:[[NSDate date] dateByRoundingUpToNearestTimeInterval:SLEEP_MODE_DATE_PICKER_MINUTE_INTERVAL * NSTimeIntervalMinute] animated:YES];
	}
}

- (void)wakeMode
{
	_datePicker.minuteInterval = WAKE_MODE_DATE_PICKER_MINUTE_INTERVAL;
	if ( self.mode != GNTimePickerModeWake ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
#warning UIButton does not animate between selected states
							 [_wakeButton setTitleColor:_selectedColor
											   forState:UIControlStateNormal];
							 [_sleepButton setTitleColor:_defaultColor
												forState:UIControlStateNormal];
							 
							 _dusk.alpha = 0.0f;
							 
							 _triangleMarker.center = (CGPoint){_wakeButton.center.x, _triangleMarker.center.y};
						 }
						 completion:^(BOOL finished) {}];
		
		[UIView animateWithDuration:ANIMATION_DURATION *3
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 _sunrise.alpha = 0.5f;
						 }
						 completion:^(BOOL finished) {}];
	} else {
		[_datePicker setDate:[[NSDate date] dateByRoundingUpToNearestTimeInterval:WAKE_MODE_DATE_PICKER_MINUTE_INTERVAL * NSTimeIntervalMinute] animated:YES];
	}
}


#pragma mark Misc.

- (void)setTintColor:(UIColor *)tintColor
{
	_tintColor = tintColor;
	_goodnightButton.tintColor = tintColor;
}

- (void)updateDatePicker
{
	[_datePicker setDate:[NSDate date] animated:NO];
}

- (void)sleepPickerDidChange:(id)sender
{
	
}


#pragma mark UIViewController Stuff

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
