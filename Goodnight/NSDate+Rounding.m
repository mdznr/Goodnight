//
//  NSDate+Rounding.m
//  Goodnight
//
//  Created by Matt Zanchelli on 11/24/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import "NSDate+Rounding.h"
#import <tgmath.h>

@implementation NSDate (Rounding)

- (NSDate *)dateByRoundingToNearestTimeInterval:(NSTimeInterval)interval
{
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval rounded = round(time/interval) * interval;
	return [NSDate dateWithTimeIntervalSince1970:rounded];
}

- (NSDate *)dateByRoundingDownToNearestTimeInterval:(NSTimeInterval)interval
{
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval rounded = floor(time/interval) * interval;
	return [NSDate dateWithTimeIntervalSince1970:rounded];
}

- (NSDate *)dateByRoundingUpToNearestTimeInterval:(NSTimeInterval)interval
{
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval rounded = ceil(time/interval) * interval;
	return [NSDate dateWithTimeIntervalSince1970:rounded];
}

@end
