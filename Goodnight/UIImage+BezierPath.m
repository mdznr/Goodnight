//
//  UIImage+BezierPath.m
//
//  Created by Matt Zanchelli on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "UIImage+BezierPath.h"

@implementation UIImage (BezierPath)

+ (UIImage *)resizableImageWithStrokedRoundedCornersOfRadius:(CGFloat)radius
													 ofColor:(UIColor *)color
												 ofThickness:(CGFloat)thickness
{
	CGFloat side = MAX(2*radius, 2);
	CGRect rect = {0, 0, side, side};
	UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:rect
											 byRoundingCorners:UIRectCornerAllCorners
												   cornerRadii:(CGSize){radius,radius}];
	bp.lineWidth = 0.0f;
	CGFloat width = bp.bounds.size.width;
	CGFloat height = bp.bounds.size.height;
	UIGraphicsBeginImageContextWithOptions((CGSize){width, height}, NO, 0.0f);
	
	CGFloat innerRadius = radius - thickness;
	UIBezierPath *bp2 = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, thickness, thickness)
											  byRoundingCorners:UIRectCornerAllCorners
													cornerRadii:(CGSize){innerRadius, innerRadius}];
	bp2.lineWidth = 0.0f;
	[bp appendPath:bp2];
	bp.usesEvenOddFillRule = YES;
	
	[color set];
	[bp fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIEdgeInsets insets = {radius, radius, radius, radius};
	image = [image resizableImageWithCapInsets:insets];
	return image;
}

+ (UIImage *)resizableImageWithRoundedCornersOfRadius:(CGFloat)radius ofColor:(UIColor *)color
{
	CGFloat side = MAX(2*radius, 2);
	CGRect rect = {0, 0, side, side};
	UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:rect
											 byRoundingCorners:UIRectCornerAllCorners
												   cornerRadii:(CGSize){radius,radius}];
	bp.lineWidth = 0.0f;
	CGFloat width = bp.bounds.size.width;
	CGFloat height = bp.bounds.size.height;
	UIGraphicsBeginImageContextWithOptions((CGSize){width, height}, NO, 0.0f);
	
	[color set];
	[bp fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIEdgeInsets insets = {radius, radius, radius, radius};
	image = [image resizableImageWithCapInsets:insets];
	return image;
}

@end
