//
//  WZCoreDelegate.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WZPurchaseInfo.h"

@protocol WZCoreDelegate <NSObject>

@required
//+(void)corePurchaseSuccess:(WZPurchaseInfo *)info;

@required
+(void)corePurchaseFailure:(NSError *)error;

@end