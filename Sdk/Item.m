//
//  Item.m
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "Item.h"

@implementation Item

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self._id = [decoder decodeObjectForKey:@"id"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.description = [decoder decodeObjectForKey:@"description"];
    self.image = [decoder decodeObjectForKey:@"image"];
    self.currency = [decoder decodeObjectForKey:@"currency"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self._id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.currency forKey:@"currency"];
}

@end
