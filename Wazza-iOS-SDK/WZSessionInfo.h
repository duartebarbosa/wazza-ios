//
//  WZSessionInfo.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZLocationInfo.h"
#import "WZDeviceInfo.h"

@interface WZSessionInfo : NSObject

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *sessionHash;
@property(nonatomic, strong) NSString *token;
@property(nonatomic) NSDate *startTime;
@property(nonatomic) NSDate *endTime;
@property(nonatomic, strong) WZLocationInfo *location;
@property(nonatomic, strong) WZDeviceInfo *device;
@property(nonatomic, strong) NSMutableArray *purchases;

-(id)initSessionInfo:(NSString *)userId;

-(void)addPurchaseId:(NSString *)pId;

-(NSDictionary *)toJson;

-(NSString *)sessionHash;

-(void)updateLocationInfo:(double)latitude :(double)longitude;

-(void)setEndDate;

@end
