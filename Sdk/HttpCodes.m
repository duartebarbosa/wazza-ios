//
//  HttpCodes.m
//  Sdk
//
//  Created by Joao Vasques on 03/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "HttpCodes.h"

@implementation HttpCodes

+(BOOL)isError:(int)code {
    return (code >= HTTPCode400BadRequest && code <= HTTPCode599NetworkConnectTimeoutErrorUnknown) ? YES: NO;
}

@end
