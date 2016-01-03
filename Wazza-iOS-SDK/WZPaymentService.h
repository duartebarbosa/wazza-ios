//
//  WZPaymentService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPayPalService.h"
#import "WZInAppPurchaseService.h"
#import "WZPaymentRequest.h"
#import "WZPaymentSystemsDelegate.h"

@interface WZPaymentService : NSObject <WZPaymentSystemsDelegate>

@property(strong) WZPayPalService *payPalService;
@property(strong) WZInAppPurchaseService *iapService;

/**
 *  Delegate to send results to Core module
 */
@property (nonatomic, weak) id<WZPaymentDelegate> delegate;

/**
 *  <#Description#>
 *
 *  @param sdkToken <#sdkToken description#>
 *  @param userId   <#userId description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initPaymentService:(NSString *)sdkToken :(NSString *)userId;


/**
 *  <#Description#>
 *
 *  @param info <#info description#>
 */
-(void)makePayment:(WZPaymentRequest *)info;

/**
 *  <#Description#>
 *
 *  @param productionClientID <#productionClientID description#>
 *  @param sandboxClientID    sandboxClientID description
 *  @param APIClientID        APIClientID description
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
                           :(BOOL)testFlag;

/**
 *  <#Description#>
 *
 *  @param view <#view description#>
 */
-(void)connectToPayPal:(UIViewController *)view;

@end
