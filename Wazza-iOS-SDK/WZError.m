//
//  WZError.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//


#import "WZError.h"

@implementation WZError

-(id)initWithMessage:(NSString *)msg {
    
    self = [super init];
    if (self) {
        self.errorMessage = msg;
    }
    
    return self;
}

@end