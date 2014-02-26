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

#define ITEMS_LIST @"ITEMS LIST"
#define DETAILS @"DETAIILS"
#define PURCHASE @"PURCHASE"

#define URL @"http://localhost:9000/api/"
#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

//Server endpoints
#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase/"

@interface SDK()

@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *secret;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;

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
        [self authenticateTest];
    }
    
    return self;
}

-(void)authenticateTest {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_AUTH];
    NSString *content = @"hello world";
//    NSData *cipheredContent = [self.securityService AES256EncryptWithKey:[self secret] :content];
//    NSString *b64Encoded = [cipheredContent base64EncodedStringWithOptions:0];
//    NSString *someString = [[NSString alloc] initWithData:cipheredContent encoding:NSASCIIStringEncoding];

    NSString *digest = [self.securityService hashContent:content];
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:[self applicationName], @"AppName", digest, @"Digest",nil];
    NSDictionary *params = nil;
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    [self.networkService httpRequest:SYNC :requestUrl :HTTP_POST :params :headers :requestData completionBlock:^(NSArray *data, NSError *error) {
        if (!error) {
            NSLog(@"DATA %@", data);
        } else {
            NSLog(@"has error: %@", error);
        }
    }];
}

-(NSDictionary *)getItems:(int)offset {
    
    NSString *requestUrl = [NSString stringWithFormat: @"%@%@%@", URL, ENDPOINT_ITEM_LIST, self.applicationName];;
    [self.networkService httpRequest:SYNC :requestUrl :HTTP_GET :nil :nil: nil completionBlock:^(NSArray *data, NSError *error){
        if (!error) {
            NSLog(@"DATA %@", data);
        } else {
            NSLog(@"has error: %@", error);
        }
    }];
    
    return Nil;
}

-(Item *)getItemDetails:(NSString *)id {
    return nil;
}

//-(NSArray *)fetchMoreItems;

-(void)makePurchase:(NSString *)itemId {
}


@end
