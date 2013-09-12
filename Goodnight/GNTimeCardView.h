//
//  GNTimeCardView.h
//  Goodnight
//
//  Created by Matt on 9/11/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	GNTimeCardViewMeteringBad,
	GNTimeCardViewMeteringPoor,
	GNTimeCardViewMeteringFine,
	GNTimeCardViewMeteringGood,
	GNTimeCardViewMeteringGreat
} GNTimeCardViewMetering;

@interface GNTimeCardView : UIView

- (id)initWithMetering:(GNTimeCardViewMetering)metering;

/// The metering level of the time card.
/// @discussion The value of this property indicates the metering mode of a time card. Changing this property updates the style of card accordingly.
@property (nonatomic) GNTimeCardViewMetering metering;

/// The date that appears on the card
@property (strong, nonatomic) NSDate *date;

@end
