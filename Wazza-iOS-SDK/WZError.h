//
//  WZError.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZError : NSObject

@property(nonatomic) NSString *errorMessage;

-(id)initWithMessage:(NSString *)msg;

@end
