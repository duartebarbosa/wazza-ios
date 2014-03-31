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

@property(nonatomic, strong) SDK *sdk;

@end

@implementation SdkTests

- (void)setUp
{
    [super setUp];
    self.sdk = [[SDK alloc] initWithCredentials:@"App" :@"d7b7e2f5280e89236ed45474"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSDKBootstrap
{
    XCTAssertTrue(self.sdk != nil);
}

-(void)testTerminate {
    [self.sdk terminate];
    XCTAssertTrue(1==1);
}

@end
