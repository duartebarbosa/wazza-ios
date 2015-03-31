//
//  IAPService.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZInAppPurchaseService.h"
#import <StoreKit/StoreKit.h>
#import "WZError.h"
#import "WZPaymentInfo.h"
#import "WZPersistenceService.h"
#import "WZInAppPurchaseInfo.h"

@interface WZInAppPurchaseService() <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property(nonatomic, strong) SKProductsRequest *productRequest;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) WZPersistenceService *persistenceService;

@end

@implementation WZInAppPurchaseService

@synthesize delegate;

-(instancetype)initService:(NSString *)userId :(NSString *)token {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.sdkToken = token;
        self.items = [[NSMutableArray alloc] init];
        self.persistenceService = [[WZPersistenceService alloc] initPersistence];
    }
    return self;
}

-(void)makePayment:(WZInAppPurchasePaymentRequest *)request {
    NSString *item = request.itemId;
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:item, nil]];
        productRequest.delegate = self;
        [productRequest start];
    } else {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@",@"Purchases disabled"];
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"io.wazza" code:200 userInfo:details];
        [self.delegate paymentFailure:error];
    }
}

-(void)executePaymentRequest:(SKProduct *)item {
    SKPayment *payment = [SKPayment paymentWithProduct:item];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma Products Request Delegate

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *products = response.products;
    NSArray *invalid = response.invalidProductIdentifiers;
    
    if (invalid.count > 0) {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@",@"request item is invalid"];
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"io.wazza" code:200 userInfo:details];
        [self.delegate paymentFailure:error];
        return;
    }
    
    if (products.count > 0) {
        [self addItem:products[0]];
        [self executePaymentRequest:products[0]];
        return;
    } else {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@",@"No product found"];
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"io.wazza" code:200 userInfo:details];
        [self.delegate paymentFailure:error];
        return;
    }
}

#pragma mark StoreKit Delegate

-(void)handleTransactionSuccess:(SKPaymentTransaction *)transaction {
    double price = 0;
    for (SKProduct *item in self.items) {
        if ([item.productIdentifier isEqualToString:transaction.payment.productIdentifier]) {
            price = [item.price doubleValue];
            [self removeItem:item];
            break;
        }
    }
    WZInAppPurchaseInfo *paymentInfo = [[WZInAppPurchaseInfo alloc] initFromTransaction:transaction :price :self.userId];
    [self.delegate paymentSuccess:paymentInfo];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                NSLog(@"Transaction of item %@ being purchased", transaction.payment.productIdentifier);
                break;
            }
            case SKPaymentTransactionStateRestored: {
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed: {
                NSLog(@"Transaction ERROR %@ | item: %@", transaction.error, transaction.payment.productIdentifier);
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:transaction.error.localizedDescription forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"io.wazza" code:200 userInfo:details];
                [self.delegate paymentFailure:error];
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                [self handleTransactionSuccess:transaction];
                break;
            }
            default:
                break;
        }
    }
}

#pragma Items management functions

-(void)addItem:(SKProduct *)item {
    if(![self.items containsObject:item]) {
        [self.items addObject:item];
    }
}

-(void)removeItem:(SKProduct *)item {
    if(![self.items containsObject:item]) {
        [self.items removeObject:item];
    }
}

@end