//
//  SdkTests.m
//  SdkTests
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Sdk.h"
#import <CoreData/CoreData.h>

@interface SdkTests : XCTestCase

@end

@implementation SdkTests

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

- (void)testSDKBootstrap
{
    SDK *sdk = [[SDK alloc] initWithCredentials:@"App" :@"d7b7e2f5280e89236ed45474"];
    XCTAssertTrue(sdk != nil);
}

@end
