//
//  WZInAppPurchaseInfo.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZInAppPurchaseInfo.h"
#import "WZSecurityService.h"

@implementation WZInAppPurchaseInfo

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)generateID {
    WZSecurityService *securityService = [[WZSecurityService alloc] init];
    NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@-%@", [self itemId], [self dateToString], [self deviceInfo]];
    return [securityService hashContent:idValue];
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)toJson {
    NSMutableDictionary *json = (NSMutableDictionary *)[super toJson];
    [json setObject:self.itemId forKey:@"itemId"];
    return json;
    
}

-(instancetype)initFromTransaction:(SKPaymentTransaction *)transaction
                                  : (double)price
                                  :(NSString *)userId {
    //TODO HASH
    self = [super initPayment:[self generateID] :transaction.payment.description :userId :price :transaction.transactionDate :transaction.payment.quantity :@"" :IAP :(transaction.error == nil)];
    if (self) {
        self.itemId = transaction.payment.productIdentifier;
        self.transaction = transaction;
    }
    
    return self;
}

-(instancetype)initForPurchase:(NSString *)userId :(NSString *)itemId :(double)price :(NSInteger)quantity {
    self = [super init];
    
    if (self) {
        self.time = [NSDate date];
        self._id = [self generateID];
        self.deviceInfo = [[WZDeviceInfo alloc] initDeviceInfo];
        self.userId = userId;
        self.itemId = itemId;
        self.price = price;
        self.quantity = quantity;
    }
    
    return self;
}

@end
