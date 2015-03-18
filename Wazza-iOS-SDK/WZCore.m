//
//  WZCore.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZCore.h"

@implementation WZCore

#pragma constructors

-(instancetype)initCore:(NSString *)token {
    return [self initCoreCommon:token :NULL];
}

-(instancetype)initCore:(NSString *)secretKey andUserId:(NSString *)userId {
    return [self initCoreCommon:secretKey :userId];
}

-(instancetype)initCoreCommon:(NSString *)token :(NSString *)userId {
    self = [super init];
    
    if (self) {
        self.userId = (userId == NULL) ? [[[UIDevice currentDevice] identifierForVendor] UUIDString] : userId;
        self.secret = token;
//        self.networkService = [[WZNetworkService alloc] initService];
//        self.securityService = [[WZSecurityService alloc] init];
//        self.persistenceService = [[WZPersistenceService alloc] initPersistence];
//        self.purchaseService = [[WZPurchaseService alloc] initService :self.userId];
//        self.sessionService = [[WZSessionService alloc] initService :self.userId :token];
//        self.purchaseService.delegate = self;
//        self.locationService = nil;
        self.payPalService = nil;
//        [self bootstrap];
    }
    
    return self;
}

#pragma PayPal Logic
-(void)initPayPalService:(NSString *)productionClientID
                        :(NSString *)sandboxClientID
                        :(NSString *)merchantName
                        :(NSString *)privacyPolicyURL
                        :(NSString *)userAgreementURL
                        :(BOOL)acceptCreditCards
                        :(BOOL)testFlag {
    self.payPalService = [[WZPayPalService alloc] initService:productionClientID
                                                             :sandboxClientID
                                                             :merchantName
                                                             :privacyPolicyURL
                                                             :userAgreementURL
                                                             :acceptCreditCards
                                                             :testFlag];
}


-(void)connectToPayPal:(UIViewController *)currentView {
    if (self.payPalService != nil) {
        [self.payPalService connect:currentView];
    } else {
        //TODO error message
        NSLog(@"WZError: need to init PayPal service first");
    }
}

-(void)fakePayPalPayment {
    if (self.payPalService != nil) {
        [self.payPalService requestPayment:@"testItem" :@"description" :@"SKU" :1 :2.99 :@"EUR" :0 :0];
    } else {
        //TODO error message
        NSLog(@"WZError: need to init PayPal service first");
    }
}

@end
