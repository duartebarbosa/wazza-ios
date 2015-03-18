//
//  WZLocationInfo.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZLocationInfo.h"

@implementation WZLocationInfo

-(id)initWithLocationData:(double)latitude :(double)longitude {
    self = [self init];
    self.latitude = latitude;
    self.longitude = longitude;
    return self;
}

@end
