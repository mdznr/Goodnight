//
//  GNTimePickerViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 10/5/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "GNTimePickerViewController.h"

#import "MTZOutlinedButton.h"
#import "MTZTriangleView.h"

@interface GNTimePickerViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *dusk;
@property (strong, nonatomic) IBOutlet UIImageView *sunrise;

@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;

@property (strong, nonatomic) IBOutlet MTZTriangleView *triangleMarker;

@property (strong, nonatomic) IBOutlet UIView *selectorView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet MTZOutlinedButton *goodnightButton;

@end

#define ANIMATION_DURATION 0.75f

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
	UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horizontal.minimumRelativeValue = @(20);
	horizontal.maximumRelativeValue = @(-20);
	UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
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
	_wakeButton.selected = NO;
	_sleepButton.selected = YES;
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

- (void)hideSun
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _dusk.alpha = 0.0f;
						 _sunrise.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)showSun
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 switch ( _mode ) {
							 case GNTimePickerModeSleep: {
								 _dusk.alpha = 1.0f;
							 } break;
							 case GNTimePickerModeWake: {
								 _sunrise.alpha = 0.5f;
							 } break;
						 }
					 }
					 completion:^(BOOL finished) {}];
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
	if ( self.mode != GNTimePickerModeSleep ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
#warning UIButton does not animate between selected states
							 _wakeButton.selected = NO;
							 _sleepButton.selected = YES;
							 
#warning move sunrise down
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
#warning move dusk up
							 _dusk.alpha = 1.0f;
						 }
						 completion:^(BOOL finished) {}];
	} else {
		[_datePicker setDate:[NSDate date] animated:YES];
	}
}

- (void)wakeMode
{
	if ( self.mode != GNTimePickerModeWake ) {
		[UIView animateWithDuration:ANIMATION_DURATION
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
#warning UIButton does not animate between selected states
							 _wakeButton.selected = YES;
							 _sleepButton.selected = NO;
							 
#warning move dusk down
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
#warning move sunrise up
							 _sunrise.alpha = 0.5f;
						 }
						 completion:^(BOOL finished) {}];
	} else {
		[_datePicker setDate:[NSDate date] animated:YES];
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
