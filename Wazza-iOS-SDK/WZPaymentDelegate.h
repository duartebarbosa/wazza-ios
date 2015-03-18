//
//  WZPaymentDelegate.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPaymentInfo.h"
#import "WZError.h"

@protocol WZPaymentDelegate <NSObject>

@required
-(void)onPurchaseFailure:(WZError *)error;

@required
-(void)onPurchaseSuccess:(WZPaymentInfo *)purchaseInfo;

@end
