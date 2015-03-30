//
//  WZNetworkService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define URL @"http://192.168.1.65:9000/api/"
#define URL @"http://146.193.224.154:9000/api/"

typedef void (^OnSuccess)(NSArray *);
typedef void (^OnFailure)(NSError *);

@interface WZNetworkService : NSObject

-(id)initService;

-(void)sendData:(NSString *)url
               :(NSDictionary *)headers
               :(NSDictionary *)data
               :(OnSuccess)success
               :(OnFailure)failure;

+(NSDictionary *)createContentForHttpPost:(NSString *)content;

@end
