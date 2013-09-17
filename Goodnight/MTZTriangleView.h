//
//  MTZTriangleView.h
//
//  Created by Matt Zanchelli on 9/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MTZTriangleOrientationPointingUp,
	MTZTriangleOrientationPointingDown,
	MTZTriangleOrientationPointingLeft,
	MTZTriangleOrientationPointingRight
} MTZTriangleOrientation;

@interface MTZTriangleView : UIView

/// The orientation of the triangle as defined as which way it is pointing in cardinal directions.
@property (nonatomic) MTZTriangleOrientation orientation;

#warning could this just be backgroundColor?
@property (strong, nonatomic) UIColor *color;

@end
