//
//  LocationInfo.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject

@property(nonatomic) double latitude;
@property(nonatomic) double longitude;

-(id)initWithLocationData:(double)latitude :(double)longitude;

@end
