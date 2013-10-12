//
//  GNSleepReminderViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 10/11/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "GNSleepReminderViewController.h"
#import "MTZOutlinedButton.h"

@interface GNSleepReminderViewController ()

@property (strong, nonatomic) IBOutlet UILabel *reminderTimeLabel;
@property (strong, nonatomic) IBOutlet MTZOutlinedButton *cancelButton;

@end

@implementation GNSleepReminderViewController

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
	
	_cancelButton.tintColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
}


#pragma mark Public API

- (CGRect)alarmTimeLabelFrame
{
	return [self.view convertRect:_reminderTimeLabel.frame
						 fromView:_reminderTimeLabel.superview];
}

- (IBAction)didCancelReminder:(id)sender
{
	if ( _delegate && [_delegate respondsToSelector:@selector(alarmViewControllerDidCancelReminder)] ) {
		[_delegate alarmViewControllerDidCancelReminder];
	}
}


#pragma UIViewController Misc.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
