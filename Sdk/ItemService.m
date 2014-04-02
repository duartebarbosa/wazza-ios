//
//  ItemService.m
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "ItemService.h"
#import "Item.h"
#import "PersistenceService.h"
#import "SecurityService.h"
#import "NetworkService.h"
#define URL @"http://localhost:9000/api/"

#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_ITEM_DETAILED_LIST @"items/details/"

@interface ItemService ()

@property(nonatomic) NSString *applicationName;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;

@end

@implementation ItemService

-(void)fetchItems:(int)offset {
    
    NSString *requestUrl = [NSString stringWithFormat: @"%@%@%@", URL, ENDPOINT_ITEM_DETAILED_LIST, self.applicationName];
    NSDictionary *headers = [self.securityService addSecurityInformation:nil];
    
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

-(Item *)getItem:(NSString *)name {
    return [self.persistenceService getItem:name];
}

-(NSArray *)getItems:(int)offset {
    return[self.persistenceService getItems:offset];
}

@end
