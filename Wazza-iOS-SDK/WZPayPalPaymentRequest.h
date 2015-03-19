//
//  WZPayPalPaymentRequest.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPaymentRequest.h"

@interface WZPayPalPaymentRequest : WZPaymentRequest

@property NSString *itemName;
@property NSString *description;
@property NSString *sku;
@property int quantity;
@property double price;
@property NSString *currency;
@property double taxCost;
@property double shippingCost;

-(instancetype)initPaymentRequest:(NSString *)itemName
                         :(NSString *)description
                         :(NSString *)sku
                         :(int)quantity
                         :(double)price
                         :(NSString *)currency
                         :(double)taxCost
                         :(double)shippingCost;

@end
