//
//  WZInAppPurchasePaymentRequest.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZInAppPurchasePaymentRequest.h"

@implementation WZInAppPurchasePaymentRequest

-(instancetype)initPaymentRequest:(NSString *)itemId {
    
    self = [super init];
    
    if (self) {
        self.itemId = itemId;
    }
    
    return self;
}

@end
