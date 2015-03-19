//
//  WZCore.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZCore.h"

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
        self.userId = (userId == NULL) ? [[[UIDevice currentDevice] identifierForVendor] UUIDString] : userId;
        self.secret = token;
        self.networkService = [[WZNetworkService alloc] initService];
        self.securityService = [[WZSecurityService alloc] init];
        self.persistenceService = [[WZPersistenceService alloc] initPersistence];
        self.purchaseService = [[WZInAppPurchaseService alloc] initService :self.userId :self.secret];
        self.sessionService = [[WZSessionService alloc] initService :self.userId :token];
        self.purchaseService.delegate = self;
        self.locationService = nil;
        self.payPalService = nil;
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

-(void)makePurchase:(NSString *)item {
    [self.purchaseService purchaseItem:item];
}

-(void)purchaseMock:(NSString *)itemid :(double)price {
    [self.purchaseService mockPurchase:self.userId :itemid :price];
}

-(void)allowGeoLocation {
    //TODO
}

#pragma mark HTTP private methods
    
-(NSString *)createStringFromJSON:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

-(NSDictionary *)createContentForHttpPost:(NSString *)content :(NSString *)requestUrl {
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    return body;
}

-(NSDictionary *)addSecurityInformation {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self secret], @"SDK-TOKEN", nil];
    return securityHeaders;
}

    
#pragma PurchaseDelegate
    
-(void)onPurchaseFailure:(WZError *)error {
    NSLog(@"received error...");
    NSError *err = nil;
    [self.delegate corePurchaseFailure:err];
}


-(void)onPurchaseSuccess:(WZPaymentInfo *)purchaseInfo {
    purchaseInfo.sessionHash = [self.sessionService getCurrentSessionHash];
    [self.sessionService addPurchasesToCurrentSession:purchaseInfo._id];
    NSDictionary *json = [purchaseInfo toJson];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, ENDPOINT_PURCHASE];
    NSString *content = [self createStringFromJSON:json];
    NSDictionary *headers = [self addSecurityInformation];
    NSDictionary *requestData = [self createContentForHttpPost:content :requestUrl];
    
    [self.networkService sendData:
                       requestUrl:
                          headers:
                      requestData:
     ^(NSArray *result){
         NSLog(@"PURCHASE SUCCESS! %@", purchaseInfo);
         [self.delegate corePurchaseSuccess:purchaseInfo];
     }:
     ^(NSError *error){
         [self.delegate corePurchaseFailure:error];
     }
     ];
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
    self.payPalService = [[WZPayPalService alloc] initService:productionClientID
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
    if (self.payPalService != nil) {
        [self.payPalService connect:currentView];
    } else {
        //TODO error message
        NSLog(@"WZError: need to init PayPal service first");
    }
}

//-(void)fakePayPalPayment {
//    if (self.payPalService != nil) {
//        [self.payPalService requestPayment:@"testItem" :@"description" :@"SKU" :1 :2.99 :@"EUR" :0 :0];
//    } else {
//        //TODO error message
//        NSLog(@"WZError: need to init PayPal service first");
//    }
//}

@end
