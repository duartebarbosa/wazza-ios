//
//  WZCore.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "WZNetworkService.h"
//#import "WZSecurityService.h"
//#import "WZPersistenceService.h"
//#import "WZPurchaseService.h"
//#import "WZSessionInfo.h"
//#import "WZLocationInfo.h"
//#import "WZPurchaseDelegate.h"
//#import "WZSessionService.h"
//#import "WZLocationService.h"
#import "WZCoreDelegate.h"
#import "WZPayPalService.h"

@interface WZCore : NSObject

@property (nonatomic, weak) id<WZCoreDelegate> delegate;
@property(nonatomic) NSString *secret;
@property(nonatomic) NSString *userId;
//@property(nonatomic, strong) WZNetworkService *networkService;
//@property(nonatomic, strong) WZSecurityService *securityService;
//@property(nonatomic, strong) WZPersistenceService *persistenceService;
//@property(nonatomic, strong) WZPurchaseService *purchaseService;
//@property(nonatomic, strong) WZSessionService *sessionService;
//@property(nonatomic, strong) WZLocationService *locationService;
@property(nonatomic, strong) NSArray *skInfo;
@property(atomic, strong) WZPayPalService *payPalService;

-(instancetype)initCore:(NSString *)secretKey;

-(instancetype)initCore:(NSString *)secretKey andUserId:(NSString *)userId;

-(void)newSession;

-(void)resumeSession;

-(void)endSession;

#pragma Purchases functions

-(void)makePurchase:(NSString *)item;

-(void)purchaseMock:(NSString *)itemid :(double)price;

#pragma PayPal logic

-(void)initPayPalService:(NSString *)productionClientID
                        :(NSString *)sandboxClientID
                        :(NSString *)merchantName
                        :(NSString *)privacyPolicyURL
                        :(NSString *)userAgreementURL
                        :(BOOL)acceptCreditCards
                        :(BOOL)testFlag;

-(void)connectToPayPal:(UIViewController *)currentView;

-(void)fakePayPalPayment;


#pragma Other stuff

-(void)allowGeoLocation;

//-(void)setUserId:(NSString *)userId;

@end