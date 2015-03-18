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

#define MAX_PAY_PAL_ITEM_NAME 127
#define MAX_PAY_PAL_ITEM_QUANTITY 10
#define MAX_PAY_PAL_ITEM_PRICE 10

@interface WZPayPalService () <PayPalPaymentDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong) UIViewController *parentController;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation WZPayPalService

-(id)initService:(NSString *)productionClientID
                :(NSString *)sandboxClientID
                :(NSString *)merchantName
                :(NSString *)privacyPolicyURL
                :(NSString *)userAgreementURL
                :(BOOL)acceptCreditCards
                :(BOOL)testFlag {
    self = [super init];
    if (self) {
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

-(void)requestPayment:(NSString *)itemName
                     :(NSString *)description
                     :(NSString *)sku
                     :(int)quantity
                     :(double)price
                     :(NSString *)currency
                     :(double)taxCost
                     :(double)shippingCost {
    
    NSDecimalNumber * _price = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", price]];
    BOOL validateInput = [self validateRequestPaymentArguments:itemName :quantity :_price :currency :sku];
    
    if (validateInput) {
        PayPalPayment *payment = [self generatePayment:itemName :description :sku :quantity :price :currency :taxCost :shippingCost];
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
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    PayPalPayment *failedPayment = self.currentPayment;
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

@end