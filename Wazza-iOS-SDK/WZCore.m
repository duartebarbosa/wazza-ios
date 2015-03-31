//
//  WZCore.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZCore.h"
#import "UtilsService.h"
#import "WZSecurityService.h"
#import "WZDeviceInfo.h"

//Server endpoints
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_ITEM_DETAILED_LIST @"items/details/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase"
#define ENDPOINT_AUTH @"auth"

#define USER_EXISTS_FLAG @"WZ_USER_EXISTS"

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
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content setObject:self.userId forKey:@"userId"];
    [content setObject:[[[WZDeviceInfo alloc] initDeviceInfo] toJson] forKey:@"device"];
   
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, ENDPOINT_AUTH];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:[WZSecurityService addSecurityInformation:self.secret]];
    if([self.persistenceService contentExists: USER_EXISTS_FLAG]) {
        [headers setObject:[[NSNumber alloc] initWithBool:YES] forKey:@"X-UserExists"];
    }
    
    [self.networkService sendData:requestUrl:
                          headers:
                          content:
     ^(NSArray *result){
         [self newSession];
     }:
     ^(NSError *error){
         NSLog(@"%@", error);
         [NSException raise:@"Wazza Authentication error" format:@"Please check your Wazza credentials"];
     }
     ];
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
    [self.delegate corePurchaseSuccess:purchaseInfo];
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
