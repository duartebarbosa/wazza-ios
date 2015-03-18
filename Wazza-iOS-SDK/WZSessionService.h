//
//  WZSessionService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZSessionInfo.h"

#define CURRENT_SESSION @"current_session"

@interface WZSessionService : NSObject

@property(nonatomic) NSString *token;
@property(nonatomic) NSString *userId;

-(id)initService :(NSString *)userId :(NSString *)token;

-(BOOL)anySessionStored;

-(void)initSession;

-(void)resumeSession;

-(void)endSession;

-(NSString *)getCurrentSessionHash;

-(WZSessionInfo *)getCurrentSession;

-(void)addPurchasesToCurrentSession:(NSString *)purchaseId;

@end
