//
//  IAPService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "WZPaymentDelegate.h"
#import "WZInAppPurchasePaymentRequest.h"

@interface WZInAppPurchaseService : NSObject

@property (nonatomic, weak) id<WZPaymentDelegate> delegate;
@property (nonatomic, strong) NSString *userId;
@property(strong) NSString *sdkToken;

-(instancetype)initService:(NSString *)userId :(NSString *)token;

-(void)makePayment:(WZInAppPurchasePaymentRequest *)request;

@end