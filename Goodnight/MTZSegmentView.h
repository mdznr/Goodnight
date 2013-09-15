//
//  MTZSegmentView.h
//
//  Created by Matt on 9/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Represents a possible state for @c MTZSegmentView
typedef enum {
	MTZSegmentStateSelected,
	MTZSegmentStateUnselected
} MTZSegmentState;

/// Represents a possible position for @c MTZSegmentView
typedef enum {
	MTZSegmentPositionTop,
	MTZSegmentPositionMiddle,
	MTZSegmentPositionBottom
} MTZSegmentPosition;

@interface MTZSegmentView : UIView

/// The position the segmented view is in (top, middle, or bottom)
/// @discussion The display of this view depends on the position it is in.
@property (nonatomic) MTZSegmentPosition position;

/// The state the segment is in (selected, unselected)
/// @discussion The display of this view depends on the state it is in.
@property (nonatomic) MTZSegmentState state;

/// The pending selection state of a segment. This is used when pressing down on a segment before releasing the touch.
@property (nonatomic) BOOL pendingSelection;

@end
