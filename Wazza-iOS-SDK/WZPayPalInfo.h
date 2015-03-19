//
//  WZPayPalInfo.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PayPalMobile.h>
#import "WZPaymentInfo.h"

@interface WZPayPalInfo : WZPaymentInfo

@property NSString *currencyCode;
@property NSString *description;
@property NSString *intent;
@property BOOL processable;

/**
 *  Response
 */
@property NSString *responseID;
@property NSString *state;
@property NSString *responseType;

/**
 *  <#Description#>
 *
 *  @param payment <#payment description#>
 *  @param userId  <#userId description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithPayPalPayment:(PayPalPayment *)payment :(NSString *)userId;

@end


/**
 PayPal result example:
 2015-03-18 16:16:59.224 demo[1231:26934] PayPal Payment Success!
 2015-03-18 16:16:59.225 demo[1231:26934]
 CurrencyCode: USD
 Amount: 2.00
 Short Description: description
 Intent: sale
 Processable: Already processed
 Display: $2.00
 Confirmation: {
 client =     {
 environment = mock;
 "paypal_sdk_version" = "2.9.0";
 platform = iOS;
 "product_name" = "PayPal iOS SDK";
 };
 response =     {
 "create_time" = "2015-03-18T16:14:48Z";
 id = "PAY-NONETWORKPAYIDEXAMPLE123";
 intent = sale;
 state = approved;
 };
 "response_type" = payment;
 }
 Details: (null)
 Shipping Address: (null)
 Invoice Number: (null)
 Custom: (null)
 Soft Descriptor: (null)
 BN code: (null)

**/