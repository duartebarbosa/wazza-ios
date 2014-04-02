//
//  SDK.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SDK.h"
#import "NetworkService.h"
#import "SecurityService.h"
#import "PersistenceService.h"
#import "PurchaseService.h"
#import "ItemService.h"
#import "SessionInfo.h"
#import "LocationInfo.h"

#define ITEMS_LIST @"ITEMS LIST"
#define DETAILS @"DETAIILS"
#define PURCHASE @"PURCHASE"

#define URL @"http://localhost:9000/api/"
#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

//Server endpoints
#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_ITEM_DETAILED_LIST @"items/details/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase"
#define ENDPOINT_SESSION_UPDATE @"session"

@interface SDK() <CLLocationManagerDelegate>

@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *secret;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;
@property(nonatomic, strong) CLLocationManager *manager;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, strong) LocationInfo *currentLocation;
@property(nonatomic, strong) PurchaseService *purchaseService;
@property(nonatomic, strong) ItemService *itemService;

@end

@implementation SDK

-(id)initWithCredentials:(NSString *)name
                        :(NSString *)secretKey {
    
    self = [super init];
    
    if(self) {
        self.applicationName = name;
        self.secret = secretKey;
        self.networkService = [[NetworkService alloc] init];
        self.securityService = [[SecurityService alloc] init];
        self.persistenceService = [[PersistenceService alloc] initPersistence];
        self.currentLocation = nil;
        if ([self isLocationServiceAvailable]) {
            self.manager = [[CLLocationManager alloc] init];
            self.manager.delegate = self;
            self.manager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.manager startUpdatingLocation];
        }
        [self bootstrap];
    }
    
    return self;
}

-(void)terminate {
    SessionInfo *info = [self.persistenceService getSessionInfo];
    [info calculateSessionLength];

    if (self.currentLocation != nil) {
        [info updateLocationInfo:self.currentLocation.latitude :self.currentLocation.longitude];
    }

    NSDictionary *json = [info toJson];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_SESSION_UPDATE];
    NSString *content = [self createStringFromJSON:json];
    NSData *requestData = [self createContentForHttpPost:content :requestUrl];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *params = nil;
    [self.networkService httpRequest:SYNC:
                          requestUrl:
                           HTTP_POST:
                              params:
                             headers:
                         requestData:
     ^(NSArray *result){
         NSLog(@"worked..");
     }:
     ^(NSError *result){
         NSLog(@"not worked..");
     }
     ];
}

-(Item *)getItem:(NSString *)name {
    return [self.persistenceService getItem:name];
}

-(NSArray *)getItems:(int)offset {
    return[self.persistenceService getItems:offset];
}


-(BOOL)makePurchase:(Item *)item {
    Purchase *purchase = [[Purchase alloc] initWithData:self.applicationName :item.name :item.currency.value];
    NSDictionary *json = [purchase toJson];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_PURCHASE];
    NSString *content = [self createStringFromJSON:json];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *params = nil;
    NSData *requestData = [self createContentForHttpPost:content :requestUrl];
    
    __block BOOL retVal = NO;
    
    [self.networkService httpRequest:
                               SYNC:
                          requestUrl:
                           HTTP_POST:
                              params:
                             headers:
                         requestData:
     ^(NSArray *result){
         retVal = YES;
     }:
     ^(NSError *result){
         retVal = NO;
     }
     ];
    
    /**
    TODO:
     - integracao com biblioteca da Apple (so help me god)
     - validacao do resultado da comunicacao com Apple
     - Enviar dados de compra (recolhidos pela Apple mais os nossos) para o backend
     - Finalizar transacção
     - Dar input ao developer (success or fail)
    **/
    return retVal;
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

-(NSData *)createContentForHttpPost:(NSString *)content :(NSString *)requestUrl {
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body
                                                          options:0
                                                            error:&error];
    return requestData;
}

-(NSDictionary *)addSecurityInformation:(NSString *)content {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self applicationName],@"AppName", nil];

    if (content) {
        [securityHeaders setValue:[self.securityService hashContent:content] forKey:@"Digest"];
    }
    return securityHeaders;
}

#pragma mark Init methods

-(void)bootstrap {
    SessionInfo *info = [[SessionInfo alloc] initWithoutLocation];
    [self.persistenceService saveSessionInfo:info];
    [self fetchItems:1];
}

-(void)fetchItems:(int)offset {
    NSString *requestUrl = [NSString stringWithFormat: @"%@%@%@", URL, ENDPOINT_ITEM_DETAILED_LIST, self.applicationName];
    NSDictionary *headers = [self addSecurityInformation:nil];
    
    [self.networkService
     httpRequest:
     SYNC:
     requestUrl:
     HTTP_GET:
     nil:
     headers:
     nil:
     ^(NSArray *result){
         for (id item in result) {
             [self.persistenceService createItemFromJson:item];
         }
     }:
     ^(NSError *result){
         NSLog(@"oops.. something went wrong");
     }
     ];
}

#pragma mark LocationManager

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot get location: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    CLLocation *loc = newLocation;
    
    if (loc != nil) {
        NSNumber *latitude = [[NSNumber alloc] initWithDouble:loc.coordinate.latitude];
        NSNumber *longitude = [[NSNumber alloc] initWithDouble:loc.coordinate.longitude];
        self.currentLocation = [[LocationInfo alloc] initWithLocationData:[latitude doubleValue] :[longitude doubleValue]];
    }
    
}

-(BOOL)isLocationServiceAvailable
{
    if([CLLocationManager locationServicesEnabled]==NO ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        return NO;
    }else{
        return YES;
    }
}

@end
