//
//  WZNetworkService.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZNetworkService.h"
#import "WZHttpCodes.h"
#import "AFHTTPRequestOperationManager.h"
#import "WZPersistenceService.h"

@interface WZNetworkService ()

@property (nonatomic, strong) dispatch_queue_t networkQueue;
@property(strong) WZPersistenceService *persistenceService;

@end

@implementation WZNetworkService

-(id)initService {
    self = [super init];
    
    if (self) {
        self.networkQueue = dispatch_queue_create("Wazza Network Queue", NULL);
        self.persistenceService = [[WZPersistenceService alloc] initPersistence];
    }
    
    return self;
}
-(void)sendData:(NSString *)url
               :(NSDictionary *)headers
               :(NSDictionary *)data
               :(OnSuccess)success
               :(OnFailure)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = responseSerializer;
    
    for (NSString* headerId in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:headerId] forHTTPHeaderField:headerId];
    }
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    dispatch_async(self.networkQueue, ^{
        [manager POST:[self escapeURL:url] parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }];
    });
    //    NSMutableURLRequest *request = [self buildRequest:url :httpMethod :params :headers :data];
    //
    //    dispatch_async(self.networkQueue, ^{
    //        [NSURLConnection sendAsynchronousRequest
    //         :request
    //         queue:[NSOperationQueue mainQueue]
    //         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //             if (!error) {
    //                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //                 int httpCode = (int)[httpResponse statusCode];
    //                 if([WZHttpCodes isError:httpCode]) {
    //                     NSError *err = [NSError errorWithDomain:@"Http code" code:httpCode userInfo:nil];
    //                     dispatch_async(dispatch_get_main_queue(), ^{
    //                         failure(err);
    //                     });
    //                 } else {
    //                     dispatch_async(dispatch_get_main_queue(), ^{
    //                         success([self parseResponse:data :error]);
    //                     });
    //                 }
    //             } else {
    //                 dispatch_async(dispatch_get_main_queue(), ^{
    //                     failure(error);
    //                 });
    //             }
    //         }];
    //    });
}

#pragma mark Private Functions

-(NSString *)escapeURL:(NSString *)url {
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)url, NULL, CFSTR(" "), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString) {
        return newString;
    } else {
        return @"";
    }
}

-(NSArray *)parseResponse: (NSData *)data :(NSError *)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

+(NSDictionary *)createContentForHttpPost:(NSString *)content {
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    return body;
}

@end
