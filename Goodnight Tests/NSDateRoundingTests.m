//
//  NSDateRoundingTests.m
//  Goodnight
//
//  Created by Matt Zanchelli on 11/25/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Rounding.h"

@interface NSDateRoundingTests : XCTestCase

@end

@implementation NSDateRoundingTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDateMinuteRounding
{
	NSDate *dateToBeRounded = [NSDate dateWithTimeIntervalSince1970:1385359548];
	NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:1385359560];
	
	NSDate *date = [dateToBeRounded dateByRoundingToNearestTimeInterval:NSTimeIntervalMinute];
	
	XCTAssertEqualObjects(date, compareDate, @"Dates not being rounded properly.");
}

- (void)testDateMinuteRoundingDown
{
	NSDate *dateToBeRounded = [NSDate dateWithTimeIntervalSince1970:1385359548];
	NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:1385359500];
	
	NSDate *date = [dateToBeRounded dateByRoundingDownToNearestTimeInterval:NSTimeIntervalMinute];
	
	XCTAssertEqualObjects(date, compareDate, @"Dates not being rounded down properly.");
}

- (void)testDateMinuteRoundingUp
{
	NSDate *dateToBeRounded = [NSDate dateWithTimeIntervalSince1970:1385359548];
	NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:1385359560];
	
	NSDate *date = [dateToBeRounded dateByRoundingUpToNearestTimeInterval:NSTimeIntervalMinute];
	
	XCTAssertEqualObjects(date, compareDate, @"Dates not being rounded up properly.");
}

@end
