//
//  SDK.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "SDK.h"
#import "NetworkService.h"
#import "SecurityService.h"
#import "PersistenceService.h"
#import "SessionInfo.h"

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

@interface SDK()

@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *secret;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;

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
        if (![self authenticateTest]) {
            self = nil;
        } else {
            [self bootstrap];
        }
    }
    
    return self;
}

-(void)terminate {
    SessionInfo *info = [self.persistenceService getSessionInfo];
    [info calculateSessionLength];
    NSDictionary *json = [info toJson];
    
    NSString *(^toJSONString)(NSDictionary *) = ^NSString *(NSDictionary * dic) {
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
    };
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_SESSION_UPDATE];
    NSString *content = toJSONString(json);
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *params = nil;
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body
                                                          options:0
                                                            error:&error];
    
    [self.networkService
     httpRequest:
     ASYNC:
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
    
    NSString *(^toJSONString)(NSDictionary *) = ^NSString *(NSDictionary * dic) {
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
    };
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_PURCHASE];
    NSString *content = toJSONString(json);
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *params = nil;
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body
                                                          options:0
                                                            error:&error];
    __block BOOL retVal = NO;
    
    [self.networkService
     httpRequest:
     ASYNC:
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

/********** PRIVATE FUNCTIONS ********/

-(NSDictionary *)addSecurityInformation:(NSString *)content {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self applicationName],@"AppName", nil];

    if (content) {
        [securityHeaders setValue:[self.securityService hashContent:content] forKey:@"Digest"];
    }
    return securityHeaders;
}

//just for test now..
-(BOOL)authenticateTest {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_AUTH];
    NSString *content = @"hello world";
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *params = nil;
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&error];
    __block BOOL retVal = NO;
    
    [self.networkService
     httpRequest:
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
    
    return retVal;
}

-(void)bootstrap {
    SessionInfo *info = [[SessionInfo alloc] initWithoutLocation];
    [self.persistenceService saveSessionInfo:info];
    [self fetchItems:0];
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

@end
