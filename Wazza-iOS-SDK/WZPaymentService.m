//
//  WZPaymentService.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZPaymentService.h"
#import "WZPaymentRequest.h"
#import "WZInAppPurchasePaymentRequest.h"
#import "WZPayPalPaymentRequest.h"

@interface WZPaymentService ()

@property(strong) NSString *_sdkToken;

@end

@implementation WZPaymentService

-(instancetype)initPaymentService:(NSString *)sdkToken :(NSString *)userId {
    
    self = [super init];
    
    if (self) {
        self._sdkToken = sdkToken;
        self.iapService = [[WZInAppPurchaseService alloc] initService:userId :sdkToken];
    }
    
    return self;
}

-(void)activatePayPalModule:(NSString *)productionClientID
                           :(NSString *)sandboxClientID
                           :(NSString *)APIClientID
                           :(NSString *)APISecret
                           :(NSString *)merchantName
                           :(NSString *)privacyPolicyURL
                           :(NSString *)userAgreementURL
                           :(BOOL)acceptCreditCards
                           :(BOOL)testFlag {
    if (self._sdkToken != nil) {
        self.payPalService = [[WZPayPalService alloc] initService:productionClientID :sandboxClientID :APIClientID :APISecret :merchantName :privacyPolicyURL :userAgreementURL :acceptCreditCards :testFlag];
    } else {
        NSLog(@"Need to call initPaymentService first");
    }
}

-(void)makePayment:(WZPaymentRequest *)info {
    if ([info isMemberOfClass:[WZInAppPurchasePaymentRequest class]]) {
        //send to IAP
    } else if ([info isMemberOfClass:[WZPayPalPaymentRequest class]]) {
        //sent to PayPal
        /**
         
         -(void)requestPayment:(NSString *)itemName
         :(NSString *)description
         :(NSString *)sku
         :(int)quantity
         :(double)price
         :(NSString *)currency
         :(double)taxCost
         :(double)shippingCost
         */
    }
}

@end
