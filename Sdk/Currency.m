//
//  Currency.m
//  SDK
//
//  Created by Joao Vasques on 21/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "Currency.h"

@implementation Currency

-(id)initWithData:(int)type :(double)value :(NSString *)currency {
    self = [super init];
    self.type = type;
    self.value = value;
    self.currency = currency;
    return self;
}

@end
