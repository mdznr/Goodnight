//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNViewController.h"

@interface GNViewController ()

// Top
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *sleepPicker;
@property (strong, nonatomic) IBOutlet UIScrollView *sleepScrollview;

// Bottom
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *wakeButton;
@property (strong, nonatomic) IBOutlet UIScrollView *wakeScrollview;
@property (strong, nonatomic) IBOutlet UIDatePicker *wakePicker;

@end


@implementation GNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
#warning store last used mode in preferences and use below
	[self setMode:GNViewControllerModeSetSleepTime];
}

- (IBAction)tappedSleepButton:(id)sender
{
	[self setMode:GNViewControllerModeSetSleepTime];
}

- (IBAction)tappedWakeButton:(id)sender
{
	[self setMode:GNViewControllerModeSetWakeTime];
}

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
	[_sleepButton.titleLabel setTextColor:[UIColor blackColor]];
	[_sleepPicker setDate:[NSDate date] animated:YES]; // Default to 'now'
	[_sleepScrollview setHidden:YES];
	[_sleepPicker setHidden:NO];
	
	
	[_bottomView setBackgroundColor:[UIColor blackColor]];
	[_wakeButton.titleLabel setTextColor:[UIColor whiteColor]];
	[_wakePicker setHidden:YES];
	[_wakeScrollview setHidden:NO];
}

- (void)wakeMode
{
	[_topView setBackgroundColor:[UIColor blackColor]];
	[_sleepButton.titleLabel setTextColor:[UIColor whiteColor]];
	[_sleepPicker setHidden:YES];
	[_sleepScrollview setHidden:NO];
	
	[_bottomView setBackgroundColor:[UIColor whiteColor]];
	[_wakeButton.titleLabel setTextColor:[UIColor blackColor]];
	[_wakeScrollview setHidden:YES];
	[_wakePicker setHidden:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	return YES;	// Support all rotations
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

@end
