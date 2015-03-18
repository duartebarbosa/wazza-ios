//
//  WazzaDelegate.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPaymentInfo.h"

/**
 *  Wazza purchase protocol.
 */
@protocol WazzaDelegate <NSObject>

/**
 *  Protocol method that's called if a purchase request is successful.
 *  After finishing all the actions related to the transaction:
 *      - Persist the purchase
 *      - Download associated content (if applicable)
 *      - Update your app's UI
 *  You must call the following function to finish the transaction on Apple's StoreKit
 *          [[SKPaymentQueue defaultQueue ] finishTransaction:info.transaction];
 */
@required
-(void)purchaseSuccess:(WZPaymentInfo *)info;

/**
 *  Protocol method that's called if there was a problem with a purchase request
 */
@required
-(void)PurchaseFailure:(NSError *)error;

@end
