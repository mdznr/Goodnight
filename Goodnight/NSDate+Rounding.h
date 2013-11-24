//
//  NSDate+Rounding.h
//  Goodnight
//
//  Created by Matt Zanchelli on 11/24/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSTimeInterval NSTimeIntervalSecond = 1;
static NSTimeInterval NSTimeIntervalMinute = 60;
static NSTimeInterval NSTimeIntervalHour = 3600;
static NSTimeInterval NSTimeIntervalDay = 86400;
static NSTimeInterval NSTimeIntervalWeek = 604800;

#warning more constants for millisecond, year, etc...
#warning year gets complicated- unsure if necessary for this scope

@interface NSDate (Rounding)

/// Returns a new NSDate object that is the receiver rounded to the nearest multiple of the time interval.
/// @param interval The time interval to round the receiver to.
/// @return A new NSDate object that is the receiver rounded to the specified time interval. The date returned might have a representation different from the receiver’s.
- (NSDate *)dateByRoundingToNearestTimeInterval:(NSTimeInterval)interval;

/// Returns a new NSDate object that is the receiver rounded down to the nearest multiple of the time interval.
/// @param interval The time interval to round the receiver down to.
/// @return A new NSDate object that is the receiver rounded down to the specified time interval. The date returned might have a representation different from the receiver’s.
- (NSDate *)dateByRoundingDownToNearestTimeInterval:(NSTimeInterval)interval;

/// Returns a new NSDate object that is the receiver rounded up to the nearest multiple of the time interval.
/// @param interval The time interval to round the receiver up to.
/// @return A new NSDate object that is the receiver rounded up to the specified time interval. The date returned might have a representation different from the receiver’s.
- (NSDate *)dateByRoundingUpToNearestTimeInterval:(NSTimeInterval)interval;

@end
