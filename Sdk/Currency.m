//
//  Currency.m
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
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
