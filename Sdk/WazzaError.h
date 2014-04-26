//
//  WazzaError.h
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WazzaError : NSObject

@property(nonatomic) NSString *errorMessage;

-(id)initWithMessage:(NSString *)msg;

@end
