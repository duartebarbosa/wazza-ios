//
//  ItemService.h
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Sdk.h"
#import "ItemDelegate.h"

@interface ItemService : NSObject

@property (nonatomic, weak) id<ItemDelegate> delegate;

-(id)initWithAppName:(NSString *)applicationName;

-(void)fetchItems:(int)offset;

-(NSString *)getItemIdFromJson:(NSDictionary *) jsonItem;

-(Item *)getItem:(NSString *)name;

-(NSArray *)getItems:(int)offset;

@end
