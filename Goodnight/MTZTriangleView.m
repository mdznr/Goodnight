//
//  MTZTriangleView.m
//
//  Created by Matt Zanchelli on 9/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZTriangleView.h"

@implementation MTZTriangleView

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
	_color = self.backgroundColor;
	self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
#warning switch on orientation
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(ctx);
	
	CGFloat left = CGRectGetMinX(rect);
	CGFloat midX = CGRectGetMidX(rect);
	CGFloat right = CGRectGetMaxX(rect);
	
	CGFloat top = CGRectGetMinY(rect);
	CGFloat midY = CGRectGetMidY(rect);
	CGFloat bottom = CGRectGetMaxY(rect);
	
	switch (_orientation) {
		case MTZTriangleOrientationPointingDown: {
			CGContextMoveToPoint   (ctx, left, top);
			CGContextAddLineToPoint(ctx, right, top);
			CGContextAddLineToPoint(ctx, midX, bottom);
		} break;
		case MTZTriangleOrientationPointingLeft: {
			CGContextMoveToPoint   (ctx, right, top);
			CGContextAddLineToPoint(ctx, left, midY);
			CGContextAddLineToPoint(ctx, right, bottom);
		} break;
		case MTZTriangleOrientationPointingRight: {
			CGContextMoveToPoint   (ctx, left, top);
			CGContextAddLineToPoint(ctx, right, midY);
			CGContextAddLineToPoint(ctx, left, bottom);
		} break;
		case MTZTriangleOrientationPointingUp: {
			CGContextMoveToPoint   (ctx, left, bottom);
			CGContextAddLineToPoint(ctx, right, bottom);
			CGContextAddLineToPoint(ctx, midX, top);
		} break;
	}
	
	
    CGContextClosePath(ctx);
	
	[_color set];
//	CGContextSetRGBFillColor(ctx, 1, 1, 0, 1);
    CGContextFillPath(ctx);
}

@end
