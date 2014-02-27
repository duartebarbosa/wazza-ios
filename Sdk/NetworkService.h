//
//  NetworkService.h
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYNC 0
#define ASYNC 1

#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

typedef void (^OnSuccess)(NSArray *);
typedef void (^OnFailure)(NSError *);

@interface NetworkService : NSObject

-(void)httpRequest:(int)reqType
                  :(NSString *)url
                  :(NSString *)httpMethod
                  :(NSDictionary *)params
                  :(NSDictionary *)headers
                  :(NSData *)data
                  :(OnSuccess)success
                  :(OnFailure)failure;
@end
