//
//  WZPayPalPaymentRequest.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZPayPalPaymentRequest.h"

@implementation WZPayPalPaymentRequest

-(instancetype)initPaymentRequest:(NSString *)itemName
                         :(NSString *)description
                         :(NSString *)sku
                         :(int)quantity
                         :(double)price
                         :(NSString *)currency
                         :(double)taxCost
                         :(double)shippingCost {

    self = [super init];
    
    if (self) {
        self.itemName = itemName;
        self.shortDescription = description;
        self.sku = sku;
        self.quantity = quantity;
        self.price = price;
        self.currency = currency;
        self.taxCost = taxCost;
        self.shippingCost = shippingCost;
    }
    
    return self;
}

@end
