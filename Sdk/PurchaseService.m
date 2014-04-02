//
//  PurchaseService.m
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "PurchaseService.h"
#import <StoreKit/StoreKit.h>

@interface PurchaseService() <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property(nonatomic, strong) SKProductsRequest *productRequest;

@end

@implementation PurchaseService

-(NSArray *)availableForPurchase:(NSArray *)items {
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:@"INAPP_PRODUCT_ID",nil];
    self.productRequest = [[SKProductsRequest alloc]
                      initWithProductIdentifiers:productIdentifiers];
    self.productRequest.delegate = self;
//    [productRequest start];
    return nil;
}
-(void)purchaseItem:(Item *)item :(PurchaseSuccess)success :(PurchaseFailure)failure {

}

#pragma mark StoreKit Delegate

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray * products = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
    }
}

@end
