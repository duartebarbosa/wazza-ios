//
//  WZPayPalService.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZPayPalService.h"
#import "PayPalMobile.h"
#import <QuartzCore/QuartzCore.h>
#import "WZPayPalInfo.h"
#import "UtilsService.h"
#import "WZNetworkService.h"
#import "WZSecurityService.h"

#define MAX_PAY_PAL_ITEM_NAME 127
#define MAX_PAY_PAL_ITEM_QUANTITY 10
#define MAX_PAY_PAL_ITEM_PRICE 10

#define VERIFY_PAYMENT_URL @"/payment/verify"

@interface WZPayPalService () <PayPalPaymentDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong) UIViewController *parentController;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(atomic, strong) NSString *apiClientID;
@property(atomic, strong) NSString *apiSecret;
@property(strong) NSString *userId;
@property(strong) WZNetworkService *networkService;
@property(strong) NSString *sdkToken;

@end

@implementation WZPayPalService

-(id)initService:(NSString *)token
                :(NSString *)productionClientID
                :(NSString *)sandboxClientID
                :(NSString *)APIClientID
                :(NSString *)APISecret
                :(NSString *)merchantName
                :(NSString *)privacyPolicyURL
                :(NSString *)userAgreementURL
                :(BOOL)acceptCreditCards
                :(BOOL)testFlag {
    self = [super init];
    if (self) {
        self.networkService = [[WZNetworkService alloc] initService];
        self.sdkToken = token;
        NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
        if (productionClientID != nil) {
            [args setObject:productionClientID forKey:PayPalEnvironmentProduction];
        }
        if (sandboxClientID != nil) {
            [args setObject:sandboxClientID forKey:PayPalEnvironmentSandbox];
        }
        
        if ([args count] == 0) {
            NSLog(@"Cannot initiate PayPal service: both IDs are nil");
            return nil;
        } else {
            [PayPalMobile initializeWithClientIdsForEnvironments:args];
            _payPalConfig = [[PayPalConfiguration alloc] init];
            _payPalConfig.acceptCreditCards = YES;
            _payPalConfig.merchantName = merchantName;
            _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:privacyPolicyURL];
            _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:userAgreementURL];
            
            testFlag ? (self.environment = PayPalEnvironmentNoNetwork) : (self.environment = PayPalEnvironmentProduction);
            
            // Setting the languageOrLocale property is optional.
            //
            // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
            // its user interface according to the device's current language setting.
            //
            // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
            // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
            // to use that language/locale.
            //
            // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
            
            _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
            
            
            // Setting the payPalShippingAddressOption property is optional.
            //
            // See PayPalConfiguration.h for details.
            
            _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        }
    }
    return self;
}

-(void)connect:(UIViewController *)viewController {
    // Preconnect to PayPal early
    self.parentController = viewController;
    [PayPalMobile preconnectWithEnvironment:self.environment];
}

//-(void)setEnvironment:(NSString *)environment {
//    self.environment = environment;
//    [self connect:self.parentController];
//}

-(BOOL)validateRequestPaymentArguments:(NSString *)name
                                      :(NSUInteger)quantity
                                      :(NSDecimalNumber *)price
                                      :(NSString *)currency
                                      :(NSString *)sku {
    return
    // name check
    (name != NULL ? [name length] <= MAX_PAY_PAL_ITEM_NAME : false) &&
    // quantity check
    (quantity > 0 && [[NSString stringWithFormat:@"%lu", (unsigned long)quantity] length] <= MAX_PAY_PAL_ITEM_QUANTITY) &&
    // price check
    ([[NSString stringWithFormat:@"%f", [price doubleValue]] length] <= MAX_PAY_PAL_ITEM_PRICE)
    
    //sku check
    ;
}

-(PayPalPayment *)generatePayment:(NSString *)itemName
                                 :(NSString *)description
                                 :(NSString *)sku
                                 :(int)quantity
                                 :(double)price
                                 :(NSString *)currency
                                 :(double)taxCost
                                 :(double)shippingCost {
    
    NSDecimalNumber * _price = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", price]];
    PayPalItem *item = [PayPalItem itemWithName:itemName
                                   withQuantity:quantity
                                      withPrice:_price
                                   withCurrency:currency
                                        withSku:sku];
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:@[item]];
    //    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", shippingCost]] withTax:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", taxCost]]];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = subtotal;
    payment.currencyCode = currency;
    payment.shortDescription = description;
    payment.paymentDetails = nil;//paymentDetails;
    self.currentPayment = payment;
    return payment;
}

-(void)makePayment:(WZPayPalPaymentRequest *)request {
    
    NSDecimalNumber * _price = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", request.price]];
    BOOL validateInput = [self validateRequestPaymentArguments:request.itemName :request.quantity :_price :request.currency :request.sku];
    
    if (validateInput) {
        PayPalPayment *payment = [self generatePayment:request.itemName
                                                      :request.description
                                                      :request.sku
                                                      :request.quantity
                                                      :request.price
                                                      :request.currency
                                                      :request.taxCost
                                                      :request.shippingCost];
        self.payPalConfig.acceptCreditCards = true;
        if (payment.processable) {
            PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                        configuration:_payPalConfig
                                                                                                             delegate:self];
            [self.parentController presentViewController:paymentViewController animated:YES completion:nil];
        } else {
            //TODO not processable: send error message
        }
    } else {
        //TODO send error message
    }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    NSLog(@"%@", completedPayment);
    WZPayPalInfo *info = [[WZPayPalInfo alloc] initWithPayPalPayment:completedPayment :self.userId];
    [self validatePayment:info :paymentViewController];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
//    PayPalPayment *failedPayment = self.currentPayment;
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

#pragma Validation methods

-(void)validatePayment:(WZPayPalInfo *)paymentInfo :(PayPalPaymentViewController *)paymentViewController {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[paymentInfo toJson], @"payment", nil];
    
    [dic setObject:self.apiClientID forKey:@"apiClientId"];
    [dic setObject:self.apiSecret forKey:@"apiSecret"];
    
//    [self.parentController dismissViewControllerAnimated:YES completion:nil];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, VERIFY_PAYMENT_URL];
    NSString *content = [UtilsService createStringFromJSON:dic];
    NSDictionary *headers = [WZSecurityService addSecurityInformation:content :self.sdkToken];
    NSDictionary *requestData = [WZNetworkService createContentForHttpPost:content :requestUrl];
    
    NSLog(@"%@", dic);

    [self.networkService sendData:
                       requestUrl:
                          headers:
                      requestData:
     ^(NSArray *result){
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
         NSLog(@"RESULT OK");
     }:
     ^(NSError *error){
         NSLog(@"%@", error);
     }
     ];
}

@end