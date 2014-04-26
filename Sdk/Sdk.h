//
//  SDK.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "PurchaseInfo.h"
#import "WazzaSDKDelegate.h"

@interface SDK : NSObject

@property (nonatomic, weak) id<WazzaSDKDelegate> delegate;

-(id)initWithCredentials:(NSString *)name
                        :(NSString *)secretKey;

-(void)allowGeoLocation;

#pragma Session functions

// -(void)resumeSession;

-(void)endSession;

#pragma Items and purchases

-(Item *)getItem:(NSString *)name;

-(NSArray *)getItems:(int)offset;

-(void)makePurchase:(Item *)item;

@end
