//
//  WZPaymentSystemsDelegae.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPaymentInfo.h"


/**
 *  <#Description#>
 */
@protocol WZPaymentSystemsDelegate <NSObject>

/**
 *  <#Description#>
 */
@required
-(void)paymentSuccess:(WZPaymentInfo *)info;

/**
 *  <#Description#>
 */
@required
-(void)paymentFailure:(NSError *)error;

@end
