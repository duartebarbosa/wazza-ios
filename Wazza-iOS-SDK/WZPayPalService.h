//
//  WZPayPalService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalMobile.h"

@interface WZPayPalService : NSObject

@property(nonatomic, strong) PayPalPayment *currentPayment;

-(id)initService:(NSString *)productionClientID
                :(NSString *)sandboxClientID
                :(NSString *)merchantName
                :(NSString *)privacyPolicyURL
                :(NSString *)userAgreementURL
                :(BOOL)acceptCreditCards
                :(BOOL)testFlag;

-(void)connect:(UIViewController *)viewController;

//-(void)setEnvironment:(NSString *)environment;

-(BOOL)validateRequestPaymentArguments:(NSString *)name
                                      :(NSUInteger)quantity
                                      :(NSDecimalNumber *)price
                                      :(NSString *)currency
                                      :(NSString *)sku;

-(void)requestPayment:(NSString *)itemName
                     :(NSString *)description
                     :(NSString *)sku
                     :(int)quantity
                     :(double)price
                     :(NSString *)currency
                     :(double)taxCost
                     :(double)shippingCost;

@end