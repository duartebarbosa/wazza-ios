//
//  ItemService.h
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface ItemService : NSObject

-(void)fetchItems:(int)offset;

-(Item *)getItem:(NSString *)name;

-(NSArray *)getItems:(int)offset;

@end
