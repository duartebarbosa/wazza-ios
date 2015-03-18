//
//  WZCurrency.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZCurrency : NSObject

@property(nonatomic) int type;
@property(nonatomic) double value;
@property(nonatomic) NSString *currency;

-(id)initWithData:(int)type :(double)value :(NSString *)currency;
-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;

@end
