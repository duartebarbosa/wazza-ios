//
//  WZInAppPurchasePaymentRequest.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPaymentRequest.h"

@interface WZInAppPurchasePaymentRequest : WZPaymentRequest

@property(strong) NSString *itemId;

-(instancetype)initPaymentRequest:(NSString *)itemId;

@end
