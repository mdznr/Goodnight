//
//  MTZOutlinedButton.m
//
//  Created by Matt Zanchelli on 9/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZOutlinedButton.h"
#import "UIImage+BezierPath.h"

@interface MTZOutlinedButton ()

@property (nonatomic) CGFloat borderWidth;

@end

@implementation MTZOutlinedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	// Setting up some defaults
	
	_borderWidth = 1.0f;
	
	// Light blue color
	[self setTintColor:[UIColor colorWithRed: 52.0f/255.0f
									   green:170.0f/255.0f
										blue:220.0f/255.0f
									   alpha:1.0f]];
	
	_cornerRadius = 8.0f;
}

- (void)setTintColor:(UIColor *)normalColor
{
	[super setTintColor:normalColor];
	
	CGFloat h,s,b,a;
	[normalColor getHue:&h
			 saturation:&s
			 brightness:&b
				  alpha:&a];
	
#warning be smarter about disbled color
	UIColor *disabledColor = [UIColor colorWithHue:h
										saturation:0.0f
										brightness:b
											 alpha:a];
	
#warning be smarter about highlighting
	UIColor *highlightedColor = [UIColor colorWithHue:h
										   saturation:s
										   brightness:b+10.0f
												alpha:a];
	
	CGFloat r = _cornerRadius;
	UIEdgeInsets insets = (UIEdgeInsets){r,r,r,r};
	
	CGRect rect = (CGRect){0, 0, 2*_cornerRadius, 2*_cornerRadius};
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
													cornerRadius:_cornerRadius];
	path.lineWidth = _borderWidth;
	
	// Regular border
	UIImage *normal = [UIImage resizableImageWithStrokedRoundedCornersOfRadius:_cornerRadius
																	   ofColor:normalColor
																   ofThickness:_borderWidth];
	[self setBackgroundImage:normal forState:UIControlStateNormal];
	[self setTitleColor:normalColor forState:UIControlStateNormal];

	// Lighter colored border
	UIImage *highlighted = [UIImage resizableImageWithStrokedRoundedCornersOfRadius:_cornerRadius
																		ofColor:highlightedColor
																		ofThickness:_borderWidth];
	[self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
	[self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
	
	// Greyscale border
	UIImage *disabled = [UIImage resizableImageWithStrokedRoundedCornersOfRadius:_cornerRadius
																		 ofColor:disabledColor
																	 ofThickness:_borderWidth];
	[self setBackgroundImage:disabled forState:UIControlStateDisabled];
	[self setTitleColor:disabledColor forState:UIControlStateDisabled];
	
	// Filled in color background
	UIImage *selected = [UIImage resizableImageWithRoundedCornersOfRadius:_cornerRadius
																  ofColor:normalColor];
	[self setBackgroundImage:selected forState:UIControlStateSelected];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
#warning be smarter about title color
}

@end
