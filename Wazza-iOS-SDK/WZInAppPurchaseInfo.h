//
//  WZInAppPurchaseInfo.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "WZPaymentInfo.h"

@interface WZInAppPurchaseInfo : WZPaymentInfo

@property(nonatomic) NSString *itemId;
@property(nonatomic, strong) SKPaymentTransaction *transaction;

/**
 *  <#Description#>
 *
 *  @param transaction <#transaction description#>
 *  @param price       <#price description#>
 *  @param userId      <#userId description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initFromTransaction:(SKPaymentTransaction *)transaction
                                  :(double)price
                                  :(NSString *)userId;

/**
 *  Creates a mock of a purchase object
 *
 *  @param itemId id of the item
 *  @param price  item's price
 *
 *  @return WZPurchaseInfo instance
 */
-(instancetype)initMockPurchase:(NSString *)userId :(NSString *)itemId :(double)price;

@end
