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
#import "WZDeviceInfo.h"

@implementation WZPaymentInfo

-(instancetype)initPayment:(NSString *)_id
                          :(NSString *)userId
                          :(double)price
                          :(NSDate *)date
                          :(NSInteger)quantity
                          :(NSString *)hash
                          :(NSUInteger)systemType {
    self = [super init];
    if (self) {
        self._id = _id;
        self.userId = userId;
        self.price = price;
        self.time = date;
        self.deviceInfo = [[WZDeviceInfo alloc] initDeviceInfo];
        self.location = nil; //TODO
        self.quantity = quantity;
        self.sessionHash = hash;
        self.paymentSystem = systemType;
    }
    return self;
}

/**
 Purchase Id format: Hash(itemID + time + device)
 **/
-(NSString *)generateID {
    WZSecurityService *securityService = [[WZSecurityService alloc] init];
    NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@", [self dateToString], [self deviceInfo]];
    return [securityService hashContent:idValue];
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)dateToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    return[formatter stringFromDate:self.time];
}

-(NSDictionary *)toJson {
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    NSString *time = [self dateToString];
    
    [json setObject:[NSNumber numberWithInteger:self.paymentSystem] forKey:@"system"];
    [json setObject:self._id forKey:@"id"];
    [json setObject:self.userId forKey:@"userId"];
    [json setObject:[[NSNumber alloc] initWithDouble:self.price] forKey:@"price"];
    [json setObject:time forKey:@"time"];
    [json setObject:[self.deviceInfo toJson] forKey:@"deviceInfo"];
    [json setObject:self.sessionHash forKey:@"sessionId"];
    
    return json;
}

@end