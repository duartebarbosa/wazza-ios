//
//  Purchase.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInfo.h"

@interface Purchase : NSObject

@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *itemId;
@property(nonatomic) double price;
@property(nonatomic) NSDate *time;
@property(nonatomic, strong) LocationInfo *location;

-(id)initWithData:(NSString *)name :(NSString *)itemId : (double)price;

@end
