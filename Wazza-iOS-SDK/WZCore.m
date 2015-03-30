//
//  WZCore.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZCore.h"
#import "UtilsService.h"

//Server endpoints
#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_ITEM_DETAILED_LIST @"items/details/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase"

@interface WZCore () <WZPaymentDelegate>

@end

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
        self.userId = (userId == nil) ? [[[UIDevice currentDevice] identifierForVendor] UUIDString] : userId;
        self.secret = token;
        self.networkService = [[WZNetworkService alloc] initService];
        self.securityService = [[WZSecurityService alloc] init];
        self.persistenceService = [[WZPersistenceService alloc] initPersistence];
        self.purchaseService = [[WZInAppPurchaseService alloc] initService :self.userId :self.secret];
        self.sessionService = [[WZSessionService alloc] initService :self.userId :token];
        self.purchaseService.delegate = self;
        self.locationService = nil;
        self.paymentService = [[WZPaymentService alloc] initPaymentService:self.secret :self.userId];
        self.paymentService.delegate = self;
        [self bootstrap];
    }
    
    return self;
}

#pragma mark Init methods
-(void)bootstrap {
    //    [self newSession];
}

-(void)newSession {
    [self.sessionService initSession];
}

-(void)resumeSession {
    [self.sessionService initSession];
}

-(void)endSession {
    [self.sessionService endSession];
}

-(void)makePayment:(WZPaymentRequest *)info {
    [self.paymentService makePayment:info];
}

-(void)allowGeoLocation {
    //TODO
}
    
#pragma PurchaseDelegate
    
-(void)onPurchaseFailure:(WZError *)error {
    NSLog(@"received error...");
    NSError *err = nil;
    [self.delegate corePurchaseFailure:err];
}


-(void)onPurchaseSuccess:(WZPaymentInfo *)purchaseInfo {
    NSLog(@"PURCHASE SUCCESS: %@", purchaseInfo);
//    purchaseInfo.sessionHash = [self.sessionService getCurrentSessionHash];
//    [self.sessionService addPurchasesToCurrentSession:purchaseInfo._id];
//    NSDictionary *json = [purchaseInfo toJson];
//    
//    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, ENDPOINT_PURCHASE];
//    NSString *content = [UtilsService createStringFromJSON:json];
//    NSDictionary *headers = [WZSecurityService addSecurityInformation:self.secret];
//    NSDictionary *requestData = [WZNetworkService createContentForHttpPost:content];
//    
//    [self.networkService sendData:
//                       requestUrl:
//                          headers:
//                      requestData:
//     ^(NSArray *result){
//         NSLog(@"PURCHASE SUCCESS! %@", purchaseInfo);
//         [self.delegate corePurchaseSuccess:purchaseInfo];
//     }:
//     ^(NSError *error){
//         [self.delegate corePurchaseFailure:error];
//     }
//     ];
}
    
    
#pragma PayPal Logic
-(void)initPayPalService:(NSString *)productionClientID
                        :(NSString *)sandboxClientID
                        :(NSString *)APIClientID
                        :(NSString *)APISecret
                        :(NSString *)merchantName
                        :(NSString *)privacyPolicyURL
                        :(NSString *)userAgreementURL
                        :(BOOL)acceptCreditCards
                        :(BOOL)testFlag {
    [self.paymentService activatePayPalModule:productionClientID
                                             :sandboxClientID
                                             :APIClientID
                                             :APISecret
                                             :merchantName
                                             :privacyPolicyURL
                                             :userAgreementURL
                                             :acceptCreditCards
                                             :testFlag];

}


-(void)connectToPayPal:(UIViewController *)currentView {
    [self.paymentService connectToPayPal:currentView];
}


@end
