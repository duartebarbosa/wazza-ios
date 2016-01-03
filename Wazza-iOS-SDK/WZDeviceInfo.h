//
//  WZDeviceInfo.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZDeviceInfo : NSObject

@property(nonatomic, strong) NSString *osName;
@property(nonatomic, strong) NSString *osVersion;
@property(nonatomic, strong) NSString *deviceModel;

-(id)initDeviceInfo;
-(id)initWithData:(NSString *)name :(NSString *)version :(NSString *)model;
-(NSDictionary *)toJson;

@end
