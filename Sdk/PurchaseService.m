//
//  PurchaseService.m
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "PurchaseService.h"
#import "ItemService.h"
#import <StoreKit/StoreKit.h>
#import "WazzaError.h"
#import "PurchaseInfo.h"

@interface PurchaseService() <SKPaymentTransactionObserver>

@property(nonatomic, strong) SKProductsRequest *productRequest;
@property(nonatomic, strong) ItemService *itemService;
@property(nonatomic, strong) NSMutableArray *items;

@end

@implementation PurchaseService

@synthesize delegate;

-(id)initWithAppName:(NSString *)appName {
    self = [super init];
    if (self) {
        self.itemService = [[ItemService alloc] initWithAppName:appName];
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)canMakePurchase {
    return [SKPaymentQueue canMakePayments];
}

-(void)purchaseItem:(SKProduct *)item {
    if ([self canMakePurchase] && item != nil) {
        SKPayment *payment = [SKPayment paymentWithProduct:item];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [self.items addObject:item];
        
    } else {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@",
                              (item == nil ?
                               @"Item is null" :
                               ([self canMakePurchase] ? nil: @"Purchases disabled"))];
        WazzaError *error = [[WazzaError alloc] initWithMessage:errorMsg];
        [self.delegate onPurchaseFailure:error];
    }
}

#pragma mark StoreKit Delegate

-(void)handleTransactionSuccess:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue ] finishTransaction:transaction];
    
    double price = 0;
    for (SKProduct *item in self.items) {
        if (item.productIdentifier == transaction.payment.productIdentifier) {
            price = [item.price doubleValue];
            break;
        }
    }
    
    [self.delegate onPurchaseSuccess:
     [[PurchaseInfo alloc] initFromTransaction:transaction appName:self.itemService.applicationName itemPrice:price]
     ];
}

-(void)paymentQueue:(SKPaymentQueue *)queue
    updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction of item %@ being purchased", transaction.payment.productIdentifier);
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"ERROR %@", transaction.error);
                [self.delegate onPurchaseFailure:[[WazzaError alloc] initWithMessage:transaction.error.localizedDescription]];
                break;
            case SKPaymentTransactionStatePurchased:
                [self handleTransactionSuccess:transaction];
                break;
            default:
                break;
        }
    }
    
}

@end
