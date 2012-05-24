//
//  GNAlarm.m
//  Goodnight
//
//  Created by Matt Zanchelli on 5/20/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "GNAlarm.h"

@interface GNAlarm ()

@end

@implementation GNAlarm

@synthesize alarmDuration = _alarmDuration;

- (void) setAnAlarm
{
	_numberOfCycles = 5; // Default number of 90min. sleep cycles
	_alarmDuration = 14 + ( _numberOfCycles * 90 );
}

@end
