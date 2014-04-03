//
//  WazzaError.m
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "WazzaError.h"

@implementation WazzaError

-(id)initWithMessage:(NSString *)msg {

    self = [super init];
    if (self) {
        self.errorMessage = msg;
    }
    
    return self;
}

@end
