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

#define ANIMATION_DURATION 0.75f

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
	
	// Create mask layer
	CALayer* maskLayer = [CALayer layer];
	UIImage *maskImage = [UIImage imageNamed:@"StatusBarContentMask.png"];
	maskLayer.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
	maskLayer.contents = (id) maskImage.CGImage;
	
	// Apply the mask to the view's layer
	self.view.layer.mask = maskLayer;
}

- (void)show
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.view.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)hide
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.view.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [_scrollView scrollRectToVisible:CGRectZero animated:NO];
					 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
