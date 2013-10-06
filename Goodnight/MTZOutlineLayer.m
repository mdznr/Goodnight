//
//  MTZOutlineLayer.m
//
//  Created by Matt Zanchelli on 9/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZOutlineLayer.h"
#import "UIImage+BezierPath.h"

@interface MTZOutlineLayer ()

@end

@implementation MTZOutlineLayer

@dynamic color, thickness, radius;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithLayer:(id)layer
{
	self = [super initWithLayer:layer];
	if (self) {
		[self setup];
		if ([layer isKindOfClass:[MTZOutlineLayer class]]) {
			MTZOutlineLayer *other = (MTZOutlineLayer *)layer;
			self.color = other.color;
			self.thickness = other.thickness;
			self.radius = other.radius;
		}
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
	// Defaults
#warning is [[UIScreen mainScreen] scale] the best option? What if mirroring?
	self.contentsScale = [[UIScreen mainScreen] scale];
	self.color = [UIColor blueColor].CGColor;
	self.radius = 4.0f;
	self.thickness = 1.0f;
}

- (CABasicAnimation *)makeAnimationForKey:(NSString *)key
{
	/*
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
	anim.fromValue = [[self presentationLayer] valueForKey:key];
//	NSLog(@"%@", [self actions]);
	CABasicAnimation *defaultAnim = (CABasicAnimation *)[CALayer defaultActionForKey:@"tintColor"];
	anim.duration = defaultAnim.duration;
	anim.timingFunction = defaultAnim.timingFunction;
	return anim;
	 */
	
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
	anim.fromValue = [[self presentationLayer] valueForKey:key];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
#warning hard-coding in easing and duration is bad!
	anim.duration = 2.25f;
	
	return anim;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
#warning eventually do thickness, and radius?
	
	if ([event isEqualToString:@"color"]) {
		return [self makeAnimationForKey:event];
	}
	
	return [super actionForKey:event];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
	return [super actionForLayer:layer forKey:event];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
#warning eventually do thickness, and radius?
	if ([key isEqualToString:@"color"]) {
		return YES;
	}
	
	return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
	/*
	CGRect rect = self.bounds;
	UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:rect
												  cornerRadius:self.radius];
	bp.lineWidth = 0.0f;
	
	CGFloat innerRadius = self.radius - self.thickness;
	CGRect innerRect = CGRectInset(rect, self.thickness, self.thickness);
	UIBezierPath *bp2 = [UIBezierPath bezierPathWithRoundedRect:innerRect
												   cornerRadius:innerRadius];
	bp2.lineWidth = 0.0f;
	[bp appendPath:bp2];
	bp.usesEvenOddFillRule = YES;
	 */
	
	CGRect rect = CGRectInset(self.bounds, self.thickness/2, self.thickness/2);
	UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:rect
												  cornerRadius:self.radius];
	bp.lineWidth = self.thickness;
	
	CGContextAddPath(ctx, bp.CGPath);
	CGContextSetFillColorWithColor(ctx, self.color);
	CGContextSetStrokeColorWithColor(ctx, self.color);
	CGContextSetLineWidth(ctx, self.thickness);
//	CGContextDrawPath(ctx, kCGPathFillStroke);
	CGContextDrawPath(ctx, kCGPathStroke);
}

@end
