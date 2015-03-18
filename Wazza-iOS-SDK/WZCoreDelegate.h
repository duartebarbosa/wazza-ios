//
//  WZCoreDelegate.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPaymentInfo.h"

@protocol WZCoreDelegate <NSObject>

@required
+(void)corePurchaseSuccess:(WZPaymentInfo *)info;

@required
+(void)corePurchaseFailure:(NSError *)error;

@end