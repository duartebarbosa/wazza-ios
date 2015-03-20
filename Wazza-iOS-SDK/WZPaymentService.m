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
#import "WZPaymentInfo.h"

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

-(void)makePayment:(WZPaymentRequest *)info {
    if ([info isMemberOfClass:[WZInAppPurchasePaymentRequest class]]) {
        [self.iapService makePayment:(WZInAppPurchasePaymentRequest *)info];
    } else if ([info isMemberOfClass:[WZPayPalPaymentRequest class]]) {
        [self.payPalService makePayment:(WZPayPalPaymentRequest *)info];
    }
}

#pragma PayPal functions

/**
 *  <#Description#>
 *
 *  @param productionClientID <#productionClientID description#>
 *  @param sandboxClientID    <#sandboxClientID description#>
 *  @param APIClientID        <#APIClientID description#>
 *  @param APISecret          <#APISecret description#>
 *  @param merchantName       <#merchantName description#>
 *  @param privacyPolicyURL   <#privacyPolicyURL description#>
 *  @param userAgreementURL   <#userAgreementURL description#>
 *  @param acceptCreditCards  <#acceptCreditCards description#>
 *  @param testFlag           <#testFlag description#>
 */
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
        self.payPalService = [[WZPayPalService alloc] initService:self._sdkToken
                                                                 :productionClientID
                                                                 :sandboxClientID
                                                                 :APIClientID
                                                                 :APISecret
                                                                 :merchantName
                                                                 :privacyPolicyURL
                                                                 :userAgreementURL
                                                                 :acceptCreditCards
                                                                 :testFlag];
        self.payPalService.delegate = self;
    } else {
        NSLog(@"Need to call initPaymentService first");
    }
}

/**
 *  <#Description#>
 *
 *  @param view <#view description#>
 */
-(void)connectToPayPal:(UIViewController *)view {
    self.payPalService != nil ? [self.payPalService connect:view] : NSLog(@"");
}

#pragma WZPaymentSystemsDelegate

/**
 *  <#Description#>
 */
-(void)paymentSuccess:(WZPaymentInfo *)info {
    NSLog(@"PAYEMNT SUCCESS: %@", info);
}

/**
 *  <#Description#>
 */
-(void)paymentFailure:(NSError *)error {

}

@end
