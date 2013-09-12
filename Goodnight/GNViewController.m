//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNViewController.h"
#import "GNTimeCardView.h"

@interface GNViewController ()

#pragma mark Private Property

// Top
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *sleepPicker;
@property (strong, nonatomic) IBOutlet UIScrollView *sleepScrollview;
@property (strong, nonatomic) GNTimeCardView *sleepCardBad;
@property (strong, nonatomic) GNTimeCardView *sleepCardPoor;
@property (strong, nonatomic) GNTimeCardView *sleepCardFine;
@property (strong, nonatomic) GNTimeCardView *sleepCardGood;
@property (strong, nonatomic) GNTimeCardView *sleepCardGreat;

// Bottom
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;
@property (strong, nonatomic) IBOutlet UIScrollView *wakeScrollview;
@property (strong, nonatomic) IBOutlet UIDatePicker *wakePicker;
@property (strong, nonatomic) GNTimeCardView *wakeCardBad;
@property (strong, nonatomic) GNTimeCardView *wakeCardPoor;
@property (strong, nonatomic) GNTimeCardView *wakeCardFine;
@property (strong, nonatomic) GNTimeCardView *wakeCardGood;
@property (strong, nonatomic) GNTimeCardView *wakeCardGreat;

@end

#define NUMBER_OF_CARDS 5

#define FALL_ASLEEP_TIME (14*60)
#define SLEEP_CYCLE_TIME (90*60)
#define GOOD_SLEEP_TIME (FALL_ASLEEP_TIME+(5*SLEEP_CYCLE_TIME))

@implementation GNViewController


#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
#warning store last used mode in preferences and use below
	[self setMode:GNViewControllerModeSetSleepTime];
	
	// Picker actions
	[_sleepPicker addTarget:self
					 action:@selector(sleepPickerDidChange:)
		   forControlEvents:UIControlEventValueChanged];
	[_wakePicker addTarget:self
					action:@selector(wakePickerDidChange:)
		  forControlEvents:UIControlEventValueChanged];
	
	// Setup cards
	_wakeCardGood = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGood];
	_wakeCardGood.center = _wakeScrollview.center;
	[_wakeScrollview addSubview:_wakeCardGood];
	
	// Configure scrollview
	_wakeScrollview.pagingEnabled = YES;
	_wakeScrollview.contentSize = (CGSize){_wakeScrollview.frame.size.width * NUMBER_OF_CARDS, _wakeScrollview.frame.size.height};
	
	// Update cards
	[self updateWakeCardTimes];
	[self updateSleepCardTimes];
}


#pragma IBActions

- (IBAction)tappedSleepButton:(id)sender
{
	[self setMode:GNViewControllerModeSetSleepTime];
	
	// Have to do this since UIDatePicker doesn't perform action for UIControlEventValueChanged when using setDate:Animated:
	[self updateWakeCardTimes];
}

- (IBAction)tappedWakeButton:(id)sender
{
	[self setMode:GNViewControllerModeSetWakeTime];
	
	// Have to do this since UIDatePicker doesn't perform action for UIControlEventValueChanged when using setDate:Animated:
	[self updateSleepCardTimes];
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

#warning animate to mode like UISegmentedControl
- (void)sleepMode
{
	[_topView setBackgroundColor:[UIColor whiteColor]];
	[_sleepButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_sleepPicker setDate:[NSDate date] animated:YES]; // Default to 'now'
	[_sleepScrollview setHidden:YES];
	[_sleepPicker setHidden:NO];
	
	
	[_bottomView setBackgroundColor:[UIColor blackColor]];
	[_wakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_wakePicker setHidden:YES];
	[_wakeScrollview setHidden:NO];
}

- (void)wakeMode
{
	[_topView setBackgroundColor:[UIColor blackColor]];
	[_sleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_sleepPicker setHidden:YES];
	[_sleepScrollview setHidden:NO];
	
	[_bottomView setBackgroundColor:[UIColor whiteColor]];
	[_wakeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_wakeScrollview setHidden:YES];
	[_wakePicker setHidden:NO];
}


#pragma mark Picker actions

- (void)sleepPickerDidChange:(id)sender
{
	[self updateWakeCardTimes];
}

- (void)updateWakeCardTimes
{
	_wakeCardGood.date = [_sleepPicker.date dateByAddingTimeInterval:GOOD_SLEEP_TIME];
}


- (void)wakePickerDidChange:(id)sender
{
	[self updateSleepCardTimes];
}

- (void)updateSleepCardTimes
{
	_sleepCardGood.date = [_sleepPicker.date dateByAddingTimeInterval:-GOOD_SLEEP_TIME];
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
