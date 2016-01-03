//
//  WZLocationService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WZLocationInfo.h"

@interface WZLocationService : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong) WZLocationInfo *currentLocation;

-(id)initService;

@end
