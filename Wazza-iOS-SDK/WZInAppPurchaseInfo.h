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
 *  Builds a model for a specific In-App Purchase
 *
 *  @param userId   id of buyer
 *  @param itemId   SKU of the item to be bought
 *  @param price    Item's price
 *  @param quantity Number of items to buy
 *
 *  @return IAP model for purchase
 */
-(instancetype)initForPurchase:(NSString *)userId :(NSString *)itemId :(double)price :(NSInteger)quantity;

@end
