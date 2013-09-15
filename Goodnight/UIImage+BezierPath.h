//
//  UIImage+BezierPath.h
//
//  Created by Matt Zanchelli on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BezierPath)

/// Create an image with a @c UIBezierPath and fill with a specified color.
/// @parameter bezierPath The @c UIBezierPath to draw into image
/// @parameter color The color to fill the @c bezierPath
+ (UIImage *)imageWithBezierPathFill:(UIBezierPath *)bezierPath withColor:(UIColor *)color;

/// Create an image with a @c UIBezierPath and stroke with a specified color
/// @parameter bezierPath The @c UIBezierPath to draw into image
/// @parameter color The color to fill the @c bezierPath
+ (UIImage *)imageWithBezierPathStroke:(UIBezierPath *)bezierPath withColor:(UIColor *)color;

@end
