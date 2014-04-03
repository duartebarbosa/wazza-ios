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

@end

@implementation PurchaseService

@synthesize delegate;

-(id)initWithAppName:(NSString *)appName {
    self = [super init];
    if (self) {
        self.itemService = [[ItemService alloc] initWithAppName:appName];
    }
    return self;
}

-(BOOL)canMakePurchase {
    return [SKPaymentQueue canMakePayments];
}

-(void)purchaseItem:(SKProduct *)item {
    if ([self canMakePurchase]) {
        SKPayment *payment = [SKPayment paymentWithProduct:item];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    } else {
        WazzaError *error = [[WazzaError alloc] initWithMessage:@"Purchases disabled"];
        [self.delegate onPurchaseFailure:error];
    }
}

#pragma mark StoreKit Delegate

-(PurchaseInfo *)createPurchaseInfoFromTransaction:(SKPaymentTransaction *)transaction {
    PurchaseInfo *p = [[PurchaseInfo alloc] init];
    return p;
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
                [self.delegate onPurchaseFailure:nil];
                break;
            case SKPaymentTransactionStatePurchased:
                [self.delegate onPurchaseSuccess:[self createPurchaseInfoFromTransaction:transaction]];
                break;
            default:
                break;
        }
    }
    
}

@end
