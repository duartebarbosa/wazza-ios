//
//  WZPayPalInfo.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZPayPalInfo.h"

@implementation WZPayPalInfo


-(instancetype)initWithPayPalPayment:(PayPalPayment *)payment :(NSString *)userId {    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormat dateFromString:payment.confirmation[@"response"][@"create_time"]];
    
    //TODO session hash
    self = [super initPayment:[self generateID] :userId :payment.amount.doubleValue :date :1 :@"HASH" :PayPal];
    
    if (self) {
        self.currencyCode = payment.currencyCode;
        self.shortDescription = payment.description;
        self.intent = payment.confirmation[@"response"][@"intent"];
        self.processable = payment.processable;
        self.responseID = payment.confirmation[@"response"][@"id"];
        self.state = payment.confirmation[@"response"][@"state"];
        self.responseType = payment.confirmation[@"response_type"];
    }
    
    return self;
}

-(NSDictionary *)toJson {
    NSMutableDictionary *json = (NSMutableDictionary *)[super toJson];
    [json setValue:self.currencyCode forKey:@"currencyCode"];
//    [json setValue:self.shortDescription forKey:@"description"];
    [json setValue:self.intent forKey:@"intent"];
    [json setValue:[NSNumber numberWithBool: self.processable] forKey:@"processable"];
    [json setValue:self.responseID forKey:@"responseID"];
    [json setValue:self.state forKey:@"state"];
    [json setValue:self.responseType forKey:@"responseType"];
    return (NSDictionary *)json;
}

@end
