//
//  LocationInfo.m
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo

-(id)initWithLocationData:(double)latitude :(double)longitude {
    self = [self init];
    self.latitude = latitude;
    self.longitude = longitude;
    return self;
}

@end
