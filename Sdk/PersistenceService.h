//
//  PersistenceService.h
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface PersistenceService : NSObject

-(id)initPersistence;
-(void)createItemFromJson:(NSDictionary *)json;
-(Item *)getItem:(NSString *)name;

@end
