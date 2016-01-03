//
//  WZPersistenceService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZSessionInfo.h"

#define SESSION_INFO @"session_info"
#define PURCHASE_INFO @"purchase_info"

@interface WZPersistenceService : NSObject


-(id)initPersistence;

-(void)storeContent:(id)content :(NSString *)key;

-(NSMutableArray *)getArrayContent:(NSString *)arrayKey;

-(void)addContentToArray:(id)content :(NSString *)arrayKey;

-(id)getContent:(NSString *)key;

-(BOOL)contentExists:(NSString *)key;

-(void)clearContent:(NSString *)key;

@end
