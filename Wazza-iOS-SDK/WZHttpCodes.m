//
//  WZHttpCodes.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZHttpCodes.h"

@implementation WZHttpCodes

+(BOOL)isError:(int)code {
    return (code >= HTTPCode400BadRequest && code <= HTTPCode599NetworkConnectTimeoutErrorUnknown) ? YES: NO;
}

@end
