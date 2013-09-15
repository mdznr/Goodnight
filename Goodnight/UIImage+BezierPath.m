//
//  UIImage+BezierPath.m
//
//  Created by Matt Zanchelli on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "UIImage+BezierPath.h"

@implementation UIImage (BezierPath)

+ (UIImage *)imageWithBezierPathFill:(UIBezierPath *)bezierPath withColor:(UIColor *)color
{
	UIGraphicsBeginImageContextWithOptions(bezierPath.bounds.size, NO, 0.0f);
	[color setStroke];
	[color setFill];
	[bezierPath stroke];
	[bezierPath fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	return image;
}

+ (UIImage *)imageWithBezierPathStroke:(UIBezierPath *)bezierPath withColor:(UIColor *)color
{
	UIGraphicsBeginImageContextWithOptions(bezierPath.bounds.size, NO, 0.0f);
	[color setStroke];
	[bezierPath stroke];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	return image;
}

@end
