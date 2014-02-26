//
//  SdkTests.m
//  SdkTests
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Sdk.h"

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

- (void)testExample
{
    SDK *sdk = [[SDK alloc] initWithCredentials:@"wazza" :@"d7b7e2f5280e89236ed45474"];
//    [sdk getItems:0];
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
