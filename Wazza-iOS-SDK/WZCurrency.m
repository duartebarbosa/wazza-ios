//
//  WZCurrency.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZCurrency.h"

@implementation WZCurrency

-(id)initWithData:(int)type :(double)value :(NSString *)currency {
    self = [super init];
    self.type = type;
    self.value = value;
    self.currency = currency;
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type = [decoder decodeIntForKey:@"type"];
    self.value = [decoder decodeDoubleForKey:@"value"];
    self.currency = [decoder decodeObjectForKey:@"currency"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeDouble:self.value forKey:@"value"];
    [encoder encodeObject:self.currency forKey:@"currency"];
}

@end
