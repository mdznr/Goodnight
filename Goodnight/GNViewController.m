//
//  GNViewController.m
//  Goodnight
//
//  Created by Matt on 5/4/12.
//  Copyright (c) 2012 Matt. All rights reserved.
//

#import "GNViewController.h"

@interface GNViewController ()

@end

@implementation GNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
