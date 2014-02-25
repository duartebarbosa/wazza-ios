//
//  Currency.h
//  SDK
//
//  Created by Joao Vasques on 21/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property(nonatomic) int type;
@property(nonatomic) double value;
@property(nonatomic) NSString *currency;

-(id)initWithData:(int)type :(double)value :(NSString *)currency;

@end
