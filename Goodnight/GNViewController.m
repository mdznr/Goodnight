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
@property (strong, nonatomic) IBOutlet UIDatePicker *wakePicker;
@property (strong, nonatomic) IBOutlet UIScrollView *wakeScrollview;
@property (strong, nonatomic) GNTimeCardView *wakeCardBad;
@property (strong, nonatomic) GNTimeCardView *wakeCardPoor;
@property (strong, nonatomic) GNTimeCardView *wakeCardFine;
@property (strong, nonatomic) GNTimeCardView *wakeCardGood;
@property (strong, nonatomic) GNTimeCardView *wakeCardGreat;

@end

#define NUMBER_OF_CARDS 5
#define DEFAULT_PAGE_INDEX 3

#define BAD_PAGE_INDEX   0
#define POOR_PAGE_INDEX  1
#define FINE_PAGE_INDEX  2
#define GOOD_PAGE_INDEX  3
#define GREAT_PAGE_INDEX 4


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
	
#warning store last used mode in preferences and use below
	[self setMode:GNViewControllerModeSetSleepTime];
	
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
	_wakeCardBad = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringBad];
	_wakeCardBad.center = (CGPoint){(BAD_PAGE_INDEX+.5)*width, height/2};
	[_wakeScrollview addSubview:_wakeCardBad];
	
	_wakeCardPoor = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringPoor];
	_wakeCardPoor.center = (CGPoint){(POOR_PAGE_INDEX+.5)*width, height/2};
	[_wakeScrollview addSubview:_wakeCardPoor];
	
	_wakeCardFine = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringFine];
	_wakeCardFine.center = (CGPoint){(FINE_PAGE_INDEX+.5)*width, height/2};
	[_wakeScrollview addSubview:_wakeCardFine];
	
	_wakeCardGood = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGood];
	_wakeCardGood.center = (CGPoint){(GOOD_PAGE_INDEX+.5)*width, height/2};
	[_wakeScrollview addSubview:_wakeCardGood];
	
	_wakeCardGreat = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGreat];
	_wakeCardGreat.center = (CGPoint){(GREAT_PAGE_INDEX+.5)*width, height/2};
	[_wakeScrollview addSubview:_wakeCardGreat];
	
	// Configure wake card scrollview
	_wakeScrollview.pagingEnabled = YES;
	_wakeScrollview.contentSize = (CGSize){width * NUMBER_OF_CARDS, height};
	_wakeScrollview.contentOffset = (CGPoint){width * DEFAULT_PAGE_INDEX, 0};
	
	// Update wake card times
	[self updateWakeCardTimes];
	
	
	// Sleep Cards
	width = _sleepScrollview.frame.size.width;
	height = _sleepScrollview.frame.size.height;
	
	// Setup sleep cards
	_sleepCardBad = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringBad];
	_sleepCardBad.center = (CGPoint){(BAD_PAGE_INDEX+.5)*width, height/2};
	[_sleepScrollview addSubview:_sleepCardBad];
	
	_sleepCardPoor = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringPoor];
	_sleepCardPoor.center = (CGPoint){(POOR_PAGE_INDEX+.5)*width, height/2};
	[_sleepScrollview addSubview:_sleepCardPoor];
	
	_sleepCardFine = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringFine];
	_sleepCardFine.center = (CGPoint){(FINE_PAGE_INDEX+.5)*width, height/2};
	[_sleepScrollview addSubview:_sleepCardFine];
	
	_sleepCardGood = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGood];
	_sleepCardGood.center = (CGPoint){(GOOD_PAGE_INDEX+.5)*width, height/2};
	[_sleepScrollview addSubview:_sleepCardGood];
	
	_sleepCardGreat = [[GNTimeCardView alloc] initWithMetering:GNTimeCardViewMeteringGreat];
	_sleepCardGreat.center = (CGPoint){(GREAT_PAGE_INDEX+.5)*width, height/2};
	[_sleepScrollview addSubview:_sleepCardGreat];
	
	// Configure sleep card scrollview
	_sleepScrollview.pagingEnabled = YES;
	_sleepScrollview.contentSize = (CGSize){width * NUMBER_OF_CARDS, height};
	_sleepScrollview.contentOffset = (CGPoint){width * DEFAULT_PAGE_INDEX, 0};
	
	// Update sleep card times
	[self updateSleepCardTimes];
}


#pragma IBActions

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
	NSDate *date = _sleepPicker.date;
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
