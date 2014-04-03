//
//  PurchaseDelegate
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseInfo.h"
#import "WazzaError.h"

@protocol PurchaseDelegate <NSObject>

@required
-(void)onPurchaseFailure:(WazzaError *)error;

@required
-(void)onPurchaseSuccess:(PurchaseInfo *)purchaseInfo;

@end
