//
//  WZPayPalInfo.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 18/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZPayPalInfo.h"

@implementation WZPayPalInfo


-(instancetype)initWithPayment:(PayPalPayment *)payment :(NSString *)userId {    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
    NSDate *date = [dateFormat dateFromString:payment.confirmation[@"response"][@"create_time"]];
    
    //TODO session hash
    self = [super initPayment:[self generateID] :userId :payment.amount.doubleValue :date :1 :@"HASH" :PayPal];
    
    if (self) {
        self.currencyCode = payment.currencyCode;
        self.description = payment.description;
        self.intent = payment.confirmation[@"response"][@"intent"];
        self.processable = payment.processable;
        self.responseID = payment.confirmation[@"response"][@"id"];
        self.state = payment.confirmation[@"response"][@"state"];
        self.responseType = payment.confirmation[@"response_type"];
    }
    
    return self;
}

-(NSDictionary *)toJson {
    NSMutableArray *json = (NSMutableArray *)[super toJson];
    [json setValue:self.currencyCode forKey:@"currencyCode"];
    [json setValue:self.description forKey:@"description"];
    [json setValue:self.intent forKey:@"intent"];
    [json setValue:[NSNumber numberWithBool: self.processable] forKey:@"processable"];
    [json setValue:self.responseID forKey:@"responseID"];
    [json setValue:self.state forKey:@"state"];
    [json setValue:self.responseType forKey:@"responseType"];
    return (NSDictionary *)json;
}

@end
