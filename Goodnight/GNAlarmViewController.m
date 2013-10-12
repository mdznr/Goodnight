//
//  GNAlarmViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 10/6/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "GNAlarmViewController.h"
#import "MTZOutlinedButton.h"

@interface GNAlarmViewController ()

@property (strong, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet MTZOutlinedButton *cancelButton;

@end

@implementation GNAlarmViewController

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
	return [self.view convertRect:_alarmTimeLabel.frame
						 fromView:_containerView];
}

- (IBAction)didCancelAlarm:(id)sender
{
	if ( _delegate && [_delegate respondsToSelector:@selector(alarmViewControllerDidCancelAlarm)] ) {
		[_delegate alarmViewControllerDidCancelAlarm];
	}
}


#pragma UIViewController Misc.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
