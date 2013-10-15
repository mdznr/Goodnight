//
//  GNTimesViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 9/19/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "GNTimesViewController.h"
#import <CoreText/CoreText.h>

#import "GNAlarmViewController.h"
#import "GNSleepReminderViewController.h"

@interface GNTimesViewController () <GNAlarmViewControllerDelegate, GNSleepReminderViewControllerDelegate>

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;

@property (strong, nonatomic) IBOutlet UILabel *instructionalLabel;

@property (strong, nonatomic) IBOutlet UIButton *time1;
@property (strong, nonatomic) IBOutlet UIButton *time2;
@property (strong, nonatomic) IBOutlet UIButton *time3;
@property (strong, nonatomic) IBOutlet UIButton *time4;

@property (strong, nonatomic) NSDate *date1;
@property (strong, nonatomic) NSDate *date2;
@property (strong, nonatomic) NSDate *date3;
@property (strong, nonatomic) NSDate *date4;

@property (strong, nonatomic) UIButton *selectedTime;
@property (nonatomic) CGRect timeFrame;

@property (strong, nonatomic) IBOutlet UIView *backButton;

@property (strong, nonatomic) GNAlarmViewController *alarmViewController;
@property (strong, nonatomic) GNSleepReminderViewController *sleepReminderViewController;

@end

#define SLEEP_IMAGE @"Sleep_Glyph_Small"
#define WAKE_IMAGE @"Wake_Glyph_Small"

#define BAD_OPACITY   0.4f
#define FINE_OPACITY  0.6f
#define GOOD_OPACITY  0.8f
#define GREAT_OPACITY 1.0f

#define FALL_ASLEEP_TIME (14*60)
#define SLEEP_CYCLE_TIME (90*60)
#define BAD_SLEEP_TIME   (FALL_ASLEEP_TIME+(3*SLEEP_CYCLE_TIME))
#define FINE_SLEEP_TIME  (FALL_ASLEEP_TIME+(4*SLEEP_CYCLE_TIME))
#define GOOD_SLEEP_TIME  (FALL_ASLEEP_TIME+(5*SLEEP_CYCLE_TIME))
#define GREAT_SLEEP_TIME (FALL_ASLEEP_TIME+(6*SLEEP_CYCLE_TIME))

#define ANIMATION_DURATION 0.75f

@implementation GNTimesViewController

#pragma mark Initializations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Getting set up

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Setup formatter
	_dateFormatter = [[NSDateFormatter alloc] init];
	_dateFormatter.dateFormat = @"h:mm a";
	
	// Setup mode specific things
	if ( _mode == GNTimesViewControllerModeSleepTimes ) {
		[self setupForSleepMode];
	} else if ( _mode == GNTimesViewControllerModeWakeTimes ) {
		[self setupForWakeMode];
	}
	
	_alarmViewController = [[GNAlarmViewController alloc] initWithNibName:@"GNAlarmViewController" bundle:nil];
	_alarmViewController.view.frame = self.view.frame;
	_alarmViewController.view.alpha = 0.0f;
	[self.view addSubview:_alarmViewController.view];
	_alarmViewController.delegate = self;
	
	_sleepReminderViewController = [[GNSleepReminderViewController alloc] initWithNibName:@"GNSleepReminderViewController" bundle:nil];
	_sleepReminderViewController.view.frame = self.view.frame;
	_sleepReminderViewController.view.alpha = 0.0f;
	[self.view addSubview:_sleepReminderViewController.view];
	_sleepReminderViewController.delegate = self;
	
	NSArray *timeFeatureSettings = @[ @{UIFontFeatureTypeIdentifierKey:    @(kNumberSpacingType),
										UIFontFeatureSelectorIdentifierKey:@(kProportionalNumbersSelector)},
                                      @{UIFontFeatureTypeIdentifierKey:    @(kCharacterAlternativesType),
										UIFontFeatureSelectorIdentifierKey:@(1)}
									];
	UIFont *font = _time1.titleLabel.font;
	UIFontDescriptor *originalDescriptor = [font fontDescriptor];
	UIFontDescriptor *timeDescriptor =
		[originalDescriptor fontDescriptorByAddingAttributes:
  			@{UIFontDescriptorFeatureSettingsAttribute:timeFeatureSettings}];
	UIFont *timeFont = [UIFont fontWithDescriptor:timeDescriptor size:36.0f];
	
	_time1.titleLabel.font = timeFont;
	_time2.titleLabel.font = timeFont;
	_time3.titleLabel.font = timeFont;
	_time4.titleLabel.font = timeFont;
	
	NSArray *altFontSettings = @[ @{UIFontFeatureTypeIdentifierKey:@(kCharacterAlternativesType),
									UIFontFeatureSelectorIdentifierKey:@(1)} ];
	UIFont *altFont = _instructionalLabel.font;
	originalDescriptor = [altFont fontDescriptor];
	UIFontDescriptor *altDescriptor =
		[originalDescriptor fontDescriptorByAddingAttributes:
  			@{UIFontDescriptorFeatureSettingsAttribute:altFontSettings}];
	_instructionalLabel.font = [UIFont fontWithDescriptor:altDescriptor size:28.0f];
}

- (void)setupForSleepMode
{
	_headerLabel.text = @"Sleep";
	
	_headerImage.image = [UIImage imageNamed:SLEEP_IMAGE];
	
	_instructionalLabel.text = @"Try falling asleep at\none of these times:";
}

- (void)setTimesForSleepMode
{
	// Times
	_date1 = [_date dateByAddingTimeInterval:-(GREAT_SLEEP_TIME+(1*60))];
	[_time1 setTitle:[_dateFormatter stringFromDate:_date1]
			forState:UIControlStateNormal];
	_time1.alpha = GREAT_OPACITY;
	
	_date2 = [_date dateByAddingTimeInterval:-(GOOD_SLEEP_TIME+(1*60))];
	[_time2 setTitle:[_dateFormatter stringFromDate:_date2]
			forState:UIControlStateNormal];
	_time2.alpha = GOOD_OPACITY;
	
	_date3 = [_date dateByAddingTimeInterval:-(FINE_SLEEP_TIME+(1*60))];
	[_time3 setTitle:[_dateFormatter stringFromDate:_date3]
			forState:UIControlStateNormal];
	_time3.alpha = FINE_OPACITY;
	
	_date4 = [_date dateByAddingTimeInterval:-(BAD_SLEEP_TIME+(1*60))];
	[_time4 setTitle:[_dateFormatter stringFromDate:_date4]
			forState:UIControlStateNormal];
	_time4.alpha = BAD_OPACITY;
}

- (void)setupForWakeMode
{
	_headerLabel.text = @"Wake";
	
	_headerImage.image = [UIImage imageNamed:WAKE_IMAGE];
	
	_instructionalLabel.text = @"Try waking up at\none of these times:";
}

- (void)setTimesForWakeMode
{
	// Times
	_date1 = [_date dateByAddingTimeInterval:BAD_SLEEP_TIME];
	[_time1 setTitle:[_dateFormatter stringFromDate:_date1]
			forState:UIControlStateNormal];
	_time1.alpha = BAD_OPACITY;
	
	_date2 = [_date dateByAddingTimeInterval:FINE_SLEEP_TIME];
	[_time2 setTitle:[_dateFormatter stringFromDate:_date2]
			forState:UIControlStateNormal];
	_time2.alpha = FINE_OPACITY;
	
	_date3 = [_date dateByAddingTimeInterval:GOOD_SLEEP_TIME];
	[_time3 setTitle:[_dateFormatter stringFromDate:_date3]
			forState:UIControlStateNormal];
	_time3.alpha = GOOD_OPACITY;
	
	_date4 = [_date dateByAddingTimeInterval:GREAT_SLEEP_TIME];
	[_time4 setTitle:[_dateFormatter stringFromDate:_date4]
			forState:UIControlStateNormal];
	_time4.alpha = GREAT_OPACITY;
}


#pragma mark Button Actions

- (IBAction)didTapBackButton:(id)sender
{
	if ( [_delegate respondsToSelector:@selector(timesViewControllerRequestsDismissal)] ) {
		[_delegate timesViewControllerRequestsDismissal];
	}
}

- (IBAction)didTapTime:(UIButton *)sender
{
	NSDate *date;
	if      ( sender == _time1 ) date = _date1;
	else if ( sender == _time2 ) date = _date2;
	else if ( sender == _time3 ) date = _date3;
	else if ( sender == _time4 ) date = _date4;
	else return; // This is not one of the times
	
	switch ( self.mode ) {
		case GNTimesViewControllerModeWakeTimes: {
			[_delegate timesViewControllerDidSetAlarm:date];
			[self didTapAlarmTime:sender];
		} break;
		case GNTimesViewControllerModeSleepTimes: {
			[_delegate timesViewControllerDidSetSleepReminder:date forWakeUpTime:_date];
			[self didTapSleepReminderTime:sender];
		} break;
	}
}

- (void)didTapAlarmTime:(UIButton *)sender
{
	// Keep track of the time's frame
	_selectedTime = sender;
	_timeFrame = sender.frame;
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _headerImage.alpha = 0.0f;
						 _headerLabel.alpha = 0.0f;
						 _instructionalLabel.alpha = 0.0f;
						 
						 if ( sender != _time1 ) _time1.alpha = 0.0f;
						 if ( sender != _time2 ) _time2.alpha = 0.0f;
						 if ( sender != _time3 ) _time3.alpha = 0.0f;
						 if ( sender != _time4 ) _time4.alpha = 0.0f;
						 
						 _backButton.alpha = 0.0f;
						 
						 sender.alpha = 0.7f;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 sender.frame = _alarmViewController.alarmTimeLabelFrame;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION/3
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _alarmViewController.view.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)didTapSleepReminderTime:(UIButton *)sender
{
	// Keep track of the time's frame
	_selectedTime = sender;
	_timeFrame = sender.frame;
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _headerImage.alpha = 0.0f;
						 _headerLabel.alpha = 0.0f;
						 _instructionalLabel.alpha = 0.0f;
						 
						 if ( sender != _time1 ) _time1.alpha = 0.0f;
						 if ( sender != _time2 ) _time2.alpha = 0.0f;
						 if ( sender != _time3 ) _time3.alpha = 0.0f;
						 if ( sender != _time4 ) _time4.alpha = 0.0f;
						 
						 _backButton.alpha = 0.0f;
						 
						 sender.alpha = 0.7f;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 sender.frame = _sleepReminderViewController.alarmTimeLabelFrame;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION/3
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _sleepReminderViewController.view.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}


#pragma mark Alarm View Controller Delegate

- (void)alarmViewControllerDidCancelAlarm
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _alarmViewController.view.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
//						 _selectedTime = nil;
//						 _timeFrame = CGRectZero;
					 }];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _selectedTime.frame = _timeFrame;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION/3
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _headerImage.alpha = 1.0f;
						 _headerLabel.alpha = 1.0f;
						 _instructionalLabel.alpha = 1.0f;
						 
						 // Indirectly resets alphas for times
						 [self setDate:_date];
						 
						 _backButton.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	[_delegate timesViewControllerDidCancelAlarm];
}


#pragma mark Sleep Reminder View Controller Delegate

- (void)sleepReminderViewControllerDidCancelReminder
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _sleepReminderViewController.view.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
//						 _selectedTime = nil;
//						 _timeFrame = CGRectZero;
					 }];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _selectedTime.frame = _timeFrame;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION/3
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _headerImage.alpha = 1.0f;
						 _headerLabel.alpha = 1.0f;
						 _instructionalLabel.alpha = 1.0f;
						 
						 // Indirectly resets alphas for times
						 [self setDate:_date];
						 
						 _backButton.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	[_delegate timesViewControllerDidCancelSleepReminder];
}


#pragma mark Properties
- (void)setMode:(GNTimesViewControllerMode)mode
{
	_mode = mode;
	if ( mode == GNTimesViewControllerModeSleepTimes ) {
		[self setupForSleepMode];
	} else if ( mode == GNTimesViewControllerModeWakeTimes ) {
		[self setupForWakeMode];
	}
}

- (void)setDate:(NSDate *)date
{
	_date = date;
	switch (_mode) {
		case GNTimesViewControllerModeSleepTimes:
			[self setTimesForSleepMode];
			break;
		case GNTimesViewControllerModeWakeTimes:
		default:
			[self setTimesForWakeMode];
			break;
	}
}


#pragma mark Animations

- (void)animateIn
{
	self.view.alpha = 0.0f;
	_backButton.alpha = 0.0f;
	_backButton.frame = CGRectOffset(_backButton.frame, 0, 16);
	
	// Bring overall alpha up
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.view.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	// Animate back button in secondary
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION/3
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:0
					 animations:^{
						 _backButton.alpha = 1.0f;
						 _backButton.frame = CGRectOffset(_backButton.frame, 0, -16);
					 }
					 completion:^(BOOL finished) {}];
	
	// Move text back below view

	// animate
	// Move text into view
}

- (void)animateOut
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.view.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _backButton.alpha = 0.0f;
						 _backButton.frame = CGRectOffset(_backButton.frame, 0, 64);
					 }];
	
	// Move text out of view
	
	// animate
	// Move text back below view
}


#pragma mark Take Down

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
