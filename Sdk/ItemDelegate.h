//
//  ItemDelegate.h
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WazzaError.h"

@protocol ItemDelegate <NSObject>

@required
-(void)onItemFetchComplete:(NSArray *)items :(WazzaError *)error;

@end
