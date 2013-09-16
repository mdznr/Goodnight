//
//  UIImage+BezierPath.h
//
//  Created by Matt Zanchelli on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BezierPath)

/// Create a resizable image with a specified corner radius stroked with a color
/// @parameter radius The corner radius of the desired image
/// @parameter color The color to fill the stroke
/// @parameter thickness The thickness of the stroke
+ (UIImage *)resizableImageWithStrokedRoundedCornersOfRadius:(CGFloat)radius
													 ofColor:(UIColor *)color
												 ofThickness:(CGFloat)thickness;

/// Create a resizable image with a specified corner radius filled with a color
/// @parameter radius The corner radius of the desired image
/// @parameter color The color to fill the image
+ (UIImage *)resizableImageWithRoundedCornersOfRadius:(CGFloat)radius
											  ofColor:(UIColor *)color;
@end
