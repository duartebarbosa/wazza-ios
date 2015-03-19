//
//  Wazza_iOS_SDK.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wazza_iOS_SDK : NSObject

/**
 *  Inits Wazza using a secret token
 *
 *  @param secretToken
 */
+(void)initWithSecret:(NSString *)secretToken;


/**
 *  Inits Wazza with secret token and user Id
 *
 *  @param secretToken unique token for authentication
 *  @param userId      unique user ID
 */
+(void)initWithSecret:(NSString *)secretToken andUserId:(NSString *)userId;

#pragma Session functions

/**
 *  Creates a new session and stores it locally
 */
+(void)newSession;


/**
 *  Sends the current session to the server
 *  TODO: write when to call this
 */
+(void)endSession;

#pragma Payments functions

/**
 *  Makes an in-app purchase request
 *
 *  @param item in-app purchase product ID
 */
+(void)makePurchase:(NSString *)item;


/**
 *  Simulates a purchase action by sending the info directely to Wazza's server
 *
 *  @param itemid item's identification
 *  @param price  item's price
 */
+(void)purchaseMock:(NSString *)itemid :(double)price;

#pragma PayPal logic

+(void)connectToPayPal:(UIViewController *)currentView;

+(void)initPayPalModule:(NSString *)productionClientID
                       :(NSString *)sandboxClientID
                       :(NSString *)APIClientID
                       :(NSString *)APISecret
                       :(NSString *)merchantName
                       :(NSString *)privacyPolicyURL
                       :(NSString *)userAgreementURL
                       :(BOOL)acceptCreditCards
                       :(BOOL)testFlag;

+(void)fakePayPalPayment;

#pragma Other stuff

/**
 *  Activates geolocation. Used on session and purchases
 */
+(void)allowGeoLocation;

/**
 *  <#Description#>
 *
 *  @param delegate <#delegate description#>
 */
+(void)setPurchaseDelegate:(id)delegate;


@end
