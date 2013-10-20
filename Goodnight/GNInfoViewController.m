//
//  GNInfoViewController.m
//  Goodnight
//
//  Created by Matt on 9/18/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import "GNInfoViewController.h"

@interface GNInfoViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *firstParagraph;

@end

@implementation GNInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// Listen to UIContentSizeCategoryDidChangeNotification (Dynamic Type)
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(preferredContentSizeDidChange:)
													 name:UIContentSizeCategoryDidChangeNotification
												   object:nil];
    }
    return self;
}

- (void)preferredContentSizeDidChange:(id)sender
{
	// Dynamic type size changed
	_firstParagraph.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	[_firstParagraph invalidateIntrinsicContentSize];
	[_scrollView invalidateIntrinsicContentSize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
