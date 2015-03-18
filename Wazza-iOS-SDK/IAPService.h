//
//  IAPService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "WZPaymentDelegate.h"

@interface IAPService : NSObject

@property (nonatomic, weak) id<WZPaymentDelegate> delegate;
@property (nonatomic, strong) NSString *userId;

-(id)initService:(NSString *)userId;

-(void)purchaseItem:(NSString *)itemId;

-(void)mockPurchase:(NSString *)userId :(NSString *)itemid :(double)price;

@end