//
//  MTZSegmentView.m
//
//  Created by Matt Zanchelli on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZSegmentView.h"
#import "UIImage+BezierPath.h"

@interface MTZSegmentView ()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *borderView;
@property (strong, nonatomic) UIView *mask;

@property (strong, nonatomic) UIColor *tintColor;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat borderWidth;

@end

#define ANIMATION_DURATION 0.21618f

@implementation MTZSegmentView

#pragma mark Initialization

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
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	
	_position = MTZSegmentPositionMiddle;
	
#warning This should be moved outside this class to be used mroe often
	UIViewAutoresizing UIViewAutoresizingSize = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;;
	
	_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
	_backgroundView.autoresizingMask = UIViewAutoresizingSize;
	[self insertSubview:_backgroundView atIndex:0];
	// Background view should always be on bottom
	
	_borderView = [[UIImageView alloc] initWithFrame:self.bounds];
	_borderView.autoresizingMask = UIViewAutoresizingSize;
	[self insertSubview:_backgroundView atIndex:0];
	
	_mask = [[UIView alloc] initWithFrame:self.bounds];
	_mask.autoresizingMask = UIViewAutoresizingSize;
	_mask.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
	_mask.opaque = NO;
	_mask.alpha = 0.0f;
	_mask.userInteractionEnabled = NO;
	[self addSubview:_mask];
	// Mask Should always be on top
	
	_tintColor = [UIColor whiteColor];
	_radius = 4.0f;
	_borderWidth = 1.0f;
}


#pragma mark Configuring Properties

- (void)setPosition:(MTZSegmentPosition)position
{
	_position = position;
	switch (position) {
			
		// Round top two corners
		case MTZSegmentPositionTop: {
			UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0, 0, 2*_radius, 2*_radius}
													 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
														   cornerRadii:(CGSize){_radius, _radius}];
			UIImage *img = [UIImage imageWithBezierPath:bp withColor:_tintColor];
			img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(_radius, _radius, _radius, _radius)];
			_backgroundView.image = img;
		} break;
			
		// Round bottom two corners
		case MTZSegmentPositionBottom: {
			UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0, 0, 2*_radius, 2*_radius}
													 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
														   cornerRadii:(CGSize){_radius, _radius}];
			UIImage *img = [UIImage imageWithBezierPath:bp withColor:_tintColor];
			img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(_radius, _radius, _radius, _radius)];
			_backgroundView.image = img;
		} break;
			
		// Round no corners
		case MTZSegmentPositionMiddle:
		default: {
			UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0, 0, 2, 2}
													 byRoundingCorners:UIRectCornerAllCorners
														   cornerRadii:CGSizeZero];
			UIImage *img = [UIImage imageWithBezierPath:bp withColor:_tintColor];
			img = [img resizableImageWithCapInsets:UIEdgeInsetsZero];
			_backgroundView.image = img;
		} break;
			
	}
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	switch (selected) {
		case YES: {
			[UIView animateWithDuration:ANIMATION_DURATION
								  delay:0.0f
				 usingSpringWithDamping:1.0f
				  initialSpringVelocity:1.0f
								options:UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
								 _backgroundView.alpha = 1.0f;
							 }
							 completion:^(BOOL finished) {}];
		} break;
		case NO: {
			[UIView animateWithDuration:ANIMATION_DURATION
								  delay:0.0f
				 usingSpringWithDamping:1.0f
				  initialSpringVelocity:1.0f
								options:UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
								 _backgroundView.alpha = 0.0f;
							 }
							 completion:^(BOOL finished) {}];
		} break;
	}
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	switch (highlighted) {
		case YES: {
			[UIView animateWithDuration:ANIMATION_DURATION
								  delay:0.0f
				 usingSpringWithDamping:1.0f
				  initialSpringVelocity:1.0f
								options:UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
								 _mask.alpha = 1.0f;
							 }
							 completion:^(BOOL finished) {}];
		} break;
		default:
		case NO: {
			[UIView animateWithDuration:ANIMATION_DURATION
								  delay:0.0f
				 usingSpringWithDamping:1.0f
				  initialSpringVelocity:1.0f
								options:UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
								 _mask.alpha = 0.0f;
							 }
							 completion:^(BOOL finished) {}];
		} break;
	}
}

#pragma mark Track Touches

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	return [super beginTrackingWithTouch:touch withEvent:event];
	
	CGPoint point = [touch locationInView:self];
	if ( [self pointInside:point withEvent:event] ) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	[super cancelTrackingWithEvent:event];
}

@end
