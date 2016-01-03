//
//  WZLocationInfo.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZLocationInfo : NSObject

@property(nonatomic) double latitude;
@property(nonatomic) double longitude;

-(id)initWithLocationData:(double)latitude :(double)longitude;

@end

