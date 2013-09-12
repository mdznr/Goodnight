//
//  GNTimeCardView.m
//  Goodnight
//
//  Created by Matt on 9/11/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import "GNTimeCardView.h"

#define meteringBadColor   [UIColor colorWithRed:239.0f/255.0f green:20.0f/255.0f  blue:17.0f/255.0f alpha:1.0];
#define meteringPoorColor  [UIColor colorWithRed:250.0f/255.0f green:91.0f/255.0f  blue:15.0f/255.0f alpha:1.0];
#define meteringFineColor  [UIColor colorWithRed:255.0f/255.0f green:157.0f/255.0f blue:23.0f/255.0f alpha:1.0];
#define meteringGoodColor  [UIColor colorWithRed:75.0f/255.0f  green:165.0f/255.0f blue:3.0f/255.0f  alpha:1.0];
#define meteringGreatColor [UIColor colorWithRed:0.0f/255.0f   green:145.0f/255.0f blue:0.0f/255.0f  alpha:1.0];

#define defaultFrame ((CGRect){0,0,128,64})

@interface GNTimeCardView ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation GNTimeCardView

- (id)init
{
	self = [super initWithFrame:defaultFrame];
	if ( self ) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( self ) {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)initWithMetering:(GNTimeCardViewMetering)metering
{
	self = [self init];
	if (self) {
		_metering = metering;
	}
	return self;
}

- (void)setup
{
	self.backgroundColor = [UIColor whiteColor];
//	self.opaque = NO;
#warning Need to do rounding of corners
	
	_timeLabel = [[UILabel alloc] initWithFrame:self.frame];
	_timeLabel.center = self.center;
	_timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_timeLabel.textAlignment = NSTextAlignmentCenter;
	_timeLabel.textColor = [UIColor blackColor];
	
	_dateFormatter = [[NSDateFormatter alloc] init];
//	_dateFormatter.dateStyle = NSDateFormatterShortStyle;
//	_dateFormatter.timeStyle = NSDateFormatterShortStyle;
	_dateFormatter.dateFormat = @"HH:mm a";
}

- (void)setMetering:(GNTimeCardViewMetering)metering
{
	_metering = metering;
	
	// Update label text color
	switch (metering) {
		case GNTimeCardViewMeteringBad:
			_timeLabel.textColor = meteringBadColor;
			break;
		case GNTimeCardViewMeteringPoor:
			_timeLabel.textColor = meteringPoorColor;
			break;
		case GNTimeCardViewMeteringFine:
			_timeLabel.textColor = meteringFineColor;
			break;
		case GNTimeCardViewMeteringGood:
			_timeLabel.textColor = meteringGoodColor;
			break;
		case GNTimeCardViewMeteringGreat:
			_timeLabel.textColor = meteringGreatColor;
			break;
	}
}

- (void)setDate:(NSDate *)date
{
	_date = date;
	
	// Update label text
	_timeLabel.text = [_dateFormatter stringFromDate:date];
}

@end
