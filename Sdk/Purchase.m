//
//  Purchase.m
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "Purchase.h"
#import "LocationInfo.h"

@implementation Purchase

-(id)initWithData:(NSString *)name :(NSString *)itemId : (double)price {
    self = [self init];
    
    self.applicationName = name;
    self.itemId = itemId;
    self.price = price;
    self.time = [NSDate date];
    self.location = Nil; //TODO
    return self;
}

@end
