//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNViewController.h"
#import "GNTimeCardView.h"
#import "MTZScrollingCardsView.h"
#import "MTZSegmentView.h"
#import <QuartzCore/QuartzCore.h>

@interface GNViewController ()

#pragma mark Private Property

// Top
@property (strong, nonatomic) IBOutlet MTZSegmentView *topView;
@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *sleepPicker;
@property (strong, nonatomic) IBOutlet MTZScrollingCardsView *sleepScrollview;
@property (strong, nonatomic) GNTimeCardView *sleepCardBad;
@property (strong, nonatomic) GNTimeCardView *sleepCardPoor;
@property (strong, nonatomic) GNTimeCardView *sleepCardFine;
@property (strong, nonatomic) GNTimeCardView *sleepCardGood;
@property (strong, nonatomic) GNTimeCardView *sleepCardGreat;

// Bottom
@property (strong, nonatomic) IBOutlet MTZSegmentView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *wakePicker;
@property (strong, nonatomic) IBOutlet MTZScrollingCardsView *wakeScrollview;
@property (strong, nonatomic) GNTimeCardView *wakeCardBad;
@property (strong, nonatomic) GNTimeCardView *wakeCardPoor;
@property (strong, nonatomic) GNTimeCardView *wakeCardFine;
@property (strong, nonatomic) GNTimeCardView *wakeCardGood;
@property (strong, nonatomic) GNTimeCardView *wakeCardGreat;

@end

#define ANIMATION_DURATION 0.2f

#define NUMBER_OF_CARDS 5

#define DEFAULT_WAKE_PAGE_INDEX 3
#define BAD_WAKE_PAGE_INDEX   0
#define POOR_WAKE_PAGE_INDEX  1
#define FINE_WAKE_PAGE_INDEX  2
#define GOOD_WAKE_PAGE_INDEX  3
#define GREAT_WAKE_PAGE_INDEX 4

#define DEFAULT_SLEEP_PAGE_INDEX 1
#define BAD_SLEEP_PAGE_INDEX   4
#define POOR_SLEEP_PAGE_INDEX  3
#define FINE_SLEEP_PAGE_INDEX  2
#define GOOD_SLEEP_PAGE_INDEX  1
#define GREAT_SLEEP_PAGE_INDEX 0

#define FALL_ASLEEP_TIME (14*60)
#define SLEEP_CYCLE_TIME (90*60)
#define BAD_SLEEP_TIME (FALL_ASLEEP_TIME+(2*SLEEP_CYCLE_TIME))
#define POOR_SLEEP_TIME (FALL_ASLEEP_TIME+(3*SLEEP_CYCLE_TIME))
#define FINE_SLEEP_TIME (FALL_ASLEEP_TIME+(4*SLEEP_CYCLE_TIME))
#define GOOD_SLEEP_TIME (FALL_ASLEEP_TIME+(5*SLEEP_CYCLE_TIME))
#define GREAT_SLEEP_TIME (FALL_ASLEEP_TIME+(6*SLEEP_CYCLE_TIME))

@implementation GNViewController


#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_topView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	_topView.position = MTZSegmentPositionTop;
	_bottomView.position = MTZSegmentPositionBottom;
	
#warning store last used mode in preferences and use below
	[self setMode:GNViewControllerModeSetSleepTime];
	
	// What events should have the pressed down state and which ones should not
	UIControlEvents down = UIControlEventTouchDown | UIControlEventTouchDragInside;
	UIControlEvents up = UIControlEventTouchCancel | UIControlEventTouchDragEnter | UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside;
	
	// Add targets to buttons for events
	[_sleepButton addTarget:self
					 action:@selector(stopTouchDownSleepButton:)
		   forControlEvents:up];
	[_sleepButton addTarget:self
					 action:@selector(touchDownSleepButton:)
		   forControlEvents:down];
	[_sleepButton addTarget:self
					 action:@selector(tappedSleepButton:)
		   forControlEvents:UIControlEventTouchUpInside];
	
	[_wakeButton addTarget:self
					action:@selector(stopTouchDownWakeButton:)
		  forControlEvents:up];
	[_wakeButton addTarget:self
					action:@selector(touchDownWakeButton:)
		  forControlEvents:down];
	[_wakeButton addTarget:self
					action:@selector(tappedWakeButton:)
		  forControlEvents:UIControlEventTouchUpInside];
	
	// Picker actions
	[_sleepPicker addTarget:self
					 action:@selector(sleepPickerDidChange:)
		   forControlEvents:UIControlEventValueChanged];
	[_wakePicker addTarget:self
					action:@selector(wakePickerDidChange:)
		  forControlEvents:UIControlEventValueChanged];
	
	CGFloat width, height;
	
	// Wake cards
	width = _wakeScrollview.frame.size.width;
	height = _wakeScrollview.frame.size.height;
	
	// Setup wake cards
	_wakeCardBad   = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringBad];
	_wakeCardPoor  = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringPoor];
	_wakeCardFine  = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringFine];
	_wakeCardGood  = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGood];
	_wakeCardGreat = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGreat];
	
	// Configure wake card scrollview
	[_wakeScrollview addPages:@[_wakeCardBad,
								_wakeCardPoor,
								_wakeCardFine,
								_wakeCardGood,
								_wakeCardGreat]];
	_wakeScrollview.currentPage = DEFAULT_WAKE_PAGE_INDEX;
#warning setting current page isn't working
	
	// Update wake card times
	[self updateWakeCardTimes];
	
	
	// Sleep Cards
	width = _sleepScrollview.frame.size.width;
	height = _sleepScrollview.frame.size.height;
	
	// Setup sleep cards
	_sleepCardBad   = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringBad];
	_sleepCardPoor  = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringPoor];
	_sleepCardFine  = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringFine];
	_sleepCardGood  = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGood];
	_sleepCardGreat = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGreat];
	
	// Configure sleep card scrollview
	[_sleepScrollview addPages:@[_sleepCardGreat,
								 _sleepCardGood,
								 _sleepCardFine,
								 _sleepCardPoor,
								 _sleepCardBad]];
	_sleepScrollview.currentPage = DEFAULT_SLEEP_PAGE_INDEX;
#warning setting current page isn't working
	
	// Update sleep card times
	[self updateSleepCardTimes];
}


#pragma mark IBActions

#warning able to tap two buttons near simultaneously
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

#warning all of these should be handled by MTZSegmentView
- (IBAction)touchDownSleepButton:(id)sender
{
	[_topView setHighlighted:YES];
}

- (IBAction)stopTouchDownSleepButton:(id)sender
{
	[_topView setHighlighted:NO];
}

- (IBAction)touchDownWakeButton:(id)sender
{
	[_bottomView setHighlighted:YES];
}

- (IBAction)stopTouchDownWakeButton:(id)sender
{
	[_bottomView setHighlighted:NO];
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
	[_topView setSelected:YES];
	[_sleepButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_sleepPicker setDate:[NSDate date] animated:YES]; // Default to 'now'
	[_sleepScrollview setHidden:YES];
	[_sleepPicker setHidden:NO];
	
	[_bottomView setSelected:NO];
	[_wakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_wakePicker setHidden:YES];
	[_wakeScrollview setHidden:NO];
}

#warning the time for the picker should be of the currently selected wake card
- (void)wakeMode
{
	[_topView setSelected:NO];
	[_sleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_sleepPicker setHidden:YES];
	[_sleepScrollview setHidden:NO];
	
	[_bottomView setSelected:YES];
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
	NSDate *date = _sleepPicker.date;
	_wakeCardBad.date   = [date dateByAddingTimeInterval:BAD_SLEEP_TIME];
	_wakeCardPoor.date  = [date dateByAddingTimeInterval:POOR_SLEEP_TIME];
	_wakeCardFine.date  = [date dateByAddingTimeInterval:FINE_SLEEP_TIME];
	_wakeCardGood.date  = [date dateByAddingTimeInterval:GOOD_SLEEP_TIME];
	_wakeCardGreat.date = [date dateByAddingTimeInterval:GREAT_SLEEP_TIME];
}


- (void)wakePickerDidChange:(id)sender
{
	[self updateSleepCardTimes];
}

- (void)updateSleepCardTimes
{
	NSDate *date = _wakePicker.date;
	_sleepCardBad.date   = [date dateByAddingTimeInterval:-BAD_SLEEP_TIME];
	_sleepCardPoor.date  = [date dateByAddingTimeInterval:-POOR_SLEEP_TIME];
	_sleepCardFine.date  = [date dateByAddingTimeInterval:-FINE_SLEEP_TIME];
	_sleepCardGood.date  = [date dateByAddingTimeInterval:-GOOD_SLEEP_TIME];
	_sleepCardGreat.date = [date dateByAddingTimeInterval:-GREAT_SLEEP_TIME];
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
