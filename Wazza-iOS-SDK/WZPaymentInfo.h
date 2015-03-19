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

typedef enum : NSUInteger {
    IAP,
    Stripe,
    PayPal,
} PaymentSystem;

@interface WZPaymentInfo : NSObject

@property(nonatomic) NSString *_id;
@property(nonatomic) NSString *userId;
@property(nonatomic) double price;
@property(nonatomic) NSDate *time;
@property(nonatomic, strong) WZLocationInfo *location;
@property(nonatomic, strong) WZDeviceInfo *deviceInfo;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) NSString *sessionHash;
@property NSUInteger paymentSystem;

-(instancetype)initPayment:(NSString *)_id
                          :(NSString *)userId
                          :(double)price
                          :(NSDate *)date
                          :(NSInteger)quantity
                          :(NSString *)hash
                          :(NSUInteger)systemType;

-(NSString *)generateID;

-(NSString *)dateToString;

-(NSDictionary *)toJson;


@end