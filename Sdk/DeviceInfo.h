//
//  DeviceInfo.h
//  Sdk
//
//  Created by Joao Vasques on 31/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

@property(nonatomic, strong) NSString *osName;
@property(nonatomic, strong) NSString *osVersion;
@property(nonatomic, strong) NSString *deviceModel;

-(id)initDeviceInfo;
-(id)initWithData:(NSString *)name :(NSString *)version :(NSString *)model;
-(NSDictionary *)toJson;

@end
