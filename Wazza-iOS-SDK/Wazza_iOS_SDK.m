//
//  Wazza_iOS_SDK.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZCore.h"
#import "Wazza_iOS_SDK.h"

static WZCore *_core = nil;
//static id<WazzaPurchaseDelegate> _delegate = nil;

@implementation Wazza_iOS_SDK

+(void)initWithSecret:(NSString *)secretToken {
    [self coreInit:secretToken :NULL];
}

+(void)initWithSecret:(NSString *)secretToken andUserId:(NSString *)userId {
    [self coreInit:secretToken :userId];
}

+(void)coreInit:(NSString *)secretToken :(NSString *)userId {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _core = (userId == NULL) ? [[WZCore alloc] initCore:secretToken] : [[WZCore alloc] initCore:secretToken andUserId:userId];
        _core.delegate = [Wazza_iOS_SDK class];
    });
}

#pragma Session functions

/**
 *  Creates a new session and stores it locally
 */
+(void)newSession {

}


/**
 *  Sends the current session to the server
 *  TODO: write when to call this
 */
+(void)endSession {

}

#pragma Payments functions

/**
 *  Makes an in-app purchase request
 *
 *  @param item in-app purchase product ID
 */
+(void)makePurchase:(NSString *)item {

}


/**
 *  Simulates a purchase action by sending the info directely to Wazza's server
 *
 *  @param itemid item's identification
 *  @param price  item's price
 */
+(void)purchaseMock:(NSString *)itemid :(double)price {

}

#pragma PayPal logic

+(void)connectToPayPal:(UIViewController *)currentView {
    (_core == nil) ? NSLog(@"") : [_core.payPalService connect:currentView];
}

+(void)initPayPalModule:(NSString *)productionClientID
                       :(NSString *)sandboxClientID
                       :(NSString *)merchantName
                       :(NSString *)privacyPolicyURL
                       :(NSString *)userAgreementURL
                       :(BOOL)acceptCreditCards
                       :(BOOL)testFlag {
    (_core == nil) ? NSLog(@"") : [_core initPayPalService:productionClientID :sandboxClientID :merchantName :privacyPolicyURL :userAgreementURL : acceptCreditCards :testFlag];
}

+(void)fakePayPalPayment {
    [_core.payPalService requestPayment:@"example item" :@"description" :@"sku" :1 : 2 : @"USD" :1 :0];
}

#pragma Other stuff

/**
 *  Activates geolocation. Used on session and purchases
 */
+(void)allowGeoLocation {

}

/**
 *  <#Description#>
 *
 *  @param delegate <#delegate description#>
 */
+(void)setPurchaseDelegate:(id)delegate {

}

@end
