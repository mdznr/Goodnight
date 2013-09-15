//
//  UIImage+BezierPath.h
//
//  Created by Matt on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BezierPath)

+ (UIImage *)imageWithBezierPath:(UIBezierPath *)bezierPath withColor:(UIColor *)color;

@end
