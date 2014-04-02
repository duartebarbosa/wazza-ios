//
//  PurchaseService.h
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Purchase.h"

@interface PurchaseService : NSObject

typedef void (^PurchaseSuccess)(Purchase *);
typedef void (^PurchaseFailure)(NSError *);

-(NSArray *)availableForPurchase:(NSArray *)items;
-(void)purchaseItem:(Item *)item :(PurchaseSuccess)success :(PurchaseFailure)failure;

@end
