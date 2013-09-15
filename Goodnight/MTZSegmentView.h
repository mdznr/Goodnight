//
//  MTZSegmentView.h
//
//  Created by Matt Zanchelli on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Represents a possible position for @c MTZSegmentView
typedef enum {
	MTZSegmentPositionTop,
	MTZSegmentPositionMiddle,
	MTZSegmentPositionBottom
} MTZSegmentPosition;

@interface MTZSegmentView : UIControl

/// The position the segmented view is in (top, middle, or bottom)
/// @discussion The display of this view depends on the position it is in.
@property (nonatomic) MTZSegmentPosition position;

/// A Boolean value that determines the receiver’s selected state.
/// @discussion Specify YES if the control is selected; otherwise NO. The default is NO.
@property (nonatomic, getter = isSelected) BOOL selected;

@end
