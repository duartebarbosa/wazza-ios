//
//  SDK.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Purchase.h"

@interface SDK : NSObject

-(id)initWithCredentials:(NSString *)name
                        :(NSString *)secretKey;

-(Item *)getItem:(NSString *)name;

-(NSArray *)getItems:(int)offset;

-(void)makePurchase:(Item *)item;

@end
