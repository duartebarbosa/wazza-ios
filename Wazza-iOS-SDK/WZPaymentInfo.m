//
//  WZPaymentInfo.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "WZPaymentInfo.h"
#import "WZLocationInfo.h"
#import "WZSecurityService.h"

@implementation WZPaymentInfo

-(id)initFromTransaction:(SKPaymentTransaction *)transaction
                        : (double)price
                        :(NSString *)userId {
    
    //    NSString*(^generateID)(void) = ^NSString* {
    //        WZSecurityService *securityService = [[WZSecurityService alloc] init];
    //        NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@-%@", self.itemId, [self dateToString], [self deviceInfo]];
    //        return [securityService hashContent:idValue];
    //    };
    
    if (self) {
        self.location = Nil; //TODO fetch most recent location if geo-location is active
        self._id = [self generateID];
        self.deviceInfo = [[WZDeviceInfo alloc] initDeviceInfo];
        self.userId = userId;
        self.itemId = transaction.payment.productIdentifier;
        self.price = price;
        self.time = transaction.transactionDate;
        self.transaction = transaction;
        self.quantity = transaction.payment.quantity;
    }
    
    return self;
}

-(id)initMockPurchase:(NSString *)userId :(NSString *)itemId :(double)price {
    self = [super init];
    
    if (self) {
        self.time = [NSDate date];
        self._id = [self generateID];
        self.deviceInfo = [[WZDeviceInfo alloc] initDeviceInfo];
        self.userId = userId;
        self.itemId = itemId;
        self.price = price;
        self.quantity = 1;
    }
    
    return self;
}

/**
 Purchase Id format: Hash(itemID + time + device)
 **/
-(NSString *)generateID {
    WZSecurityService *securityService = [[WZSecurityService alloc] init];
    NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@-%@", self.itemId, [self dateToString], [self deviceInfo]];
    return [securityService hashContent:idValue];
}

-(NSString *)dateToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    return[formatter stringFromDate:self.time];
}

-(NSDictionary *)toJson {
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    NSString *time = [self dateToString];
    
    [json setObject:self._id forKey:@"id"];
    [json setObject:self.userId forKey:@"userId"];
    [json setObject:self.itemId forKey:@"itemId"];
    [json setObject:[[NSNumber alloc] initWithDouble:self.price] forKey:@"price"];
    [json setObject:time forKey:@"time"];
    [json setObject:[self.deviceInfo toJson] forKey:@"deviceInfo"];
    [json setObject:self.sessionHash forKey:@"sessionId"];
    
    return json;
}

@end