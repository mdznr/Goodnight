//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNViewController.h"

@interface GNViewController ()

@end

@implementation GNViewController

@synthesize alarm = _alarm;

- (IBAction)didSayGoodnight:(UIButton *)sender {
	
	//	Set alarm for 5 90-minute cycles (for now)
	//	scheduleLocalNotification:
	//	Change text to Cancel alarm for x:xx
	
	int numberOfSleepCycles = 5;
	NSTimeInterval sleepTime = numberOfSleepCycles*60*60*90;
	NSTimeInterval temp = 15;
	NSDate* alarmTime = [[NSDate alloc] initWithTimeIntervalSinceNow:temp];
	
	if ( [[sender currentTitle] isEqualToString:@"Goodnight"] )
	{
		NSLog(@"didSayGoodnight: %@", sender.titleLabel.text);
		//	set alarm
		_alarm.fireDate = alarmTime;
		_alarm.timeZone = [NSTimeZone defaultTimeZone];
		_alarm.alertBody = @"It's time to wake up!";
		_alarm.alertAction = @"Wake Up";
		_alarm.soundName = UILocalNotificationDefaultSoundName;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:_alarm];
		NSLog(@"registered notifications: %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
		[sender setTitle:@"Cancel Alarm" forState:UIControlStateNormal];
	}

	else if ( [[sender currentTitle] isEqualToString:@"Cancel Alarm"] )
	{
		NSLog(@"didSayGoodnight: %@", sender.titleLabel.text);
		//	cancel alarm
		[[UIApplication sharedApplication] cancelLocalNotification:_alarm];
		[sender setTitle:@"Goodnight" forState:UIControlStateNormal];
	}
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_alarm = [[UILocalNotification alloc] init];
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
