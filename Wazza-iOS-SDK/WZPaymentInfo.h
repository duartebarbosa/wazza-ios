//
//  WZPaymentInfo.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WZLocationInfo.h"
#import "WZDeviceInfo.h"
#import <StoreKit/StoreKit.h>

@interface WZPaymentInfo : NSObject

@property(nonatomic) NSString *_id;
@property(nonatomic) NSString *userId;
@property(nonatomic) NSString *itemId;
@property(nonatomic) double price;
@property(nonatomic) NSDate *time;
@property(nonatomic, strong) WZLocationInfo *location;
@property(nonatomic, strong) WZDeviceInfo *deviceInfo;
@property(nonatomic, strong) SKPaymentTransaction *transaction;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) NSString *sessionHash;

-(id)initFromTransaction:(SKPaymentTransaction *)transaction
                        :(double)price
                        :(NSString *)userId;

-(NSDictionary *)toJson;

/**
 *  Creates a mock of a purchase object
 *
 *  @param itemId id of the item
 *  @param price  item's price
 *
 *  @return WZPurchaseInfo instance
 */
-(id)initMockPurchase:(NSString *)userId :(NSString *)itemId :(double)price;

@end