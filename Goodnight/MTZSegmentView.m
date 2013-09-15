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
	
#warning This should be moved outside this class to be used more often
	UIViewAutoresizing UIViewAutoresizingSize = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;;
	
	_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
	_backgroundView.autoresizingMask = UIViewAutoresizingSize;
	[self insertSubview:_backgroundView atIndex:0];
	// Background view should always be on bottom
	
	_borderView = [[UIImageView alloc] initWithFrame:self.bounds];
	_borderView.autoresizingMask = UIViewAutoresizingSize;
	[self insertSubview:_borderView atIndex:0];
	// Border view should always be on bottom
	
#warning the corners for mask should be rounded properly
	_mask = [[UIView alloc] initWithFrame:self.bounds];
	_mask.autoresizingMask = UIViewAutoresizingSize;
	_mask.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
	_mask.opaque = NO;
	_mask.alpha = 0.0f;
	_mask.userInteractionEnabled = NO;
	[self addSubview:_mask];
	// Mask Should always be on top
	
	_tintColor = [UIColor whiteColor];
	_radius = 6.0f;
	_borderWidth = 1.0f;
	
	[self addTarget:self
			 action:@selector(didTouchUpInside:)
   forControlEvents:UIControlEventTouchUpInside];
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
			bp.lineWidth = _borderWidth;
			UIEdgeInsets insets = UIEdgeInsetsMake(_radius, _radius, _radius, _radius);
			
			UIImage *bgImg = [UIImage imageWithBezierPathFill:bp withColor:_tintColor];
			bgImg = [bgImg resizableImageWithCapInsets:insets];
			_backgroundView.image = bgImg;
			
			UIImage *brdrImg = [UIImage imageWithBezierPathStroke:bp withColor:_tintColor];
			brdrImg = [brdrImg resizableImageWithCapInsets:insets];
			_borderView.image = brdrImg;
		} break;
			
		// Round bottom two corners
		case MTZSegmentPositionBottom: {
			UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0, 0, 2*_radius, 2*_radius}
													 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
														   cornerRadii:(CGSize){_radius, _radius}];
			bp.lineWidth = _borderWidth;
			UIEdgeInsets insets = UIEdgeInsetsMake(_radius, _radius, _radius, _radius);
			
			UIImage *img = [UIImage imageWithBezierPathFill:bp withColor:_tintColor];
			img = [img resizableImageWithCapInsets:insets];
			_backgroundView.image = img;
			
			UIImage *brdrImg = [UIImage imageWithBezierPathStroke:bp withColor:_tintColor];
			brdrImg = [brdrImg resizableImageWithCapInsets:insets];
			_borderView.image = brdrImg;
		} break;
			
		// Round no corners
		case MTZSegmentPositionMiddle:
		default: {
			UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0, 0, 2, 2}
													 byRoundingCorners:UIRectCornerAllCorners
														   cornerRadii:CGSizeZero];
			bp.lineWidth = _borderWidth;
			UIImage *img = [UIImage imageWithBezierPathFill:bp withColor:_tintColor];
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


#pragma mark Misc.

- (void)didTouchUpInside:(id)sender
{
	[self setSelected:YES];
}

@end
