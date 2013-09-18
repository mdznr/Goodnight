//
//  MTZOutlineLayer.h
//
//  Created by Matt Zanchelli on 9/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface MTZOutlineLayer : CALayer

///
@property (nonatomic) CGColorRef color;

///
@property (nonatomic) CGFloat thickness;

///
@property (nonatomic) CGFloat radius;

@end
