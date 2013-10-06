//
//  GNTimesViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 9/19/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "GNTimesViewController.h"

@interface GNTimesViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;

@property (strong, nonatomic) IBOutlet UILabel *instructionalLabel;

@property (strong, nonatomic) IBOutlet UIButton *time1;
@property (strong, nonatomic) IBOutlet UIButton *time2;
@property (strong, nonatomic) IBOutlet UIButton *time3;
@property (strong, nonatomic) IBOutlet UIButton *time4;

@property (strong, nonatomic) IBOutlet UIView *backButton;

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
	NSDate *date;
	date = [_date dateByAddingTimeInterval:-GREAT_SLEEP_TIME];
	[_time1 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time1.alpha = GREAT_OPACITY;
	
	date = [_date dateByAddingTimeInterval:-GOOD_SLEEP_TIME];
	[_time2 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time2.alpha = GOOD_OPACITY;
	
	date = [_date dateByAddingTimeInterval:-FINE_SLEEP_TIME];
	[_time3 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time3.alpha = FINE_OPACITY;
	
	date = [_date dateByAddingTimeInterval:-BAD_SLEEP_TIME];
	[_time4 setTitle:[_dateFormatter stringFromDate:date]
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
	NSDate *date;
	date = [_date dateByAddingTimeInterval:BAD_SLEEP_TIME];
	[_time1 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time1.alpha = BAD_OPACITY;
	
	date = [_date dateByAddingTimeInterval:FINE_SLEEP_TIME];
	[_time2 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time2.alpha = FINE_OPACITY;
	
	date = [_date dateByAddingTimeInterval:GOOD_SLEEP_TIME];
	[_time3 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time3.alpha = GOOD_OPACITY;
	
	date = [_date dateByAddingTimeInterval:GREAT_SLEEP_TIME];
	[_time4 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time4.alpha = GREAT_OPACITY;
}


#pragma mark Button Actions

- (IBAction)didTapBackButton:(id)sender
{
	if ( _delegate && [_delegate respondsToSelector:@selector(timesViewControllerRequestsDismissal)] ) {
		[_delegate timesViewControllerRequestsDismissal];
	}
}

- (IBAction)didTapTime:(id)sender
{
	// Set date - switch depending on button
	NSDate *date;
	switch ( self.mode ) {
		case GNTimesViewControllerModeWakeTimes: {
			[_delegate timesViewControllerSetWakeAlarmForTime:date];
		} break;
		case GNTimesViewControllerModeSleepTimes: {
			[_delegate timesViewControllerSetSleepReminderForTime:date];
		} break;
	}
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
	// Move text back below view

	// animate
	// Move text into view
}

- (void)animateOut
{
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
