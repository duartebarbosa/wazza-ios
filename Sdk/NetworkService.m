//
//  NetworkService.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

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

-(NSMutableURLRequest *)buildRequest:(NSString *)url
                               :(NSString *)httpMethod
                               :(NSDictionary *)params
                               :(NSDictionary *)headers
                               :(NSData *)data {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self escapeURL:url]]];
    [request setHTTPMethod:httpMethod];

    if ([httpMethod isEqualToString:HTTP_POST]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: data];
    }

    void(^addHeaders)(NSDictionary *) = ^(NSDictionary *h) {
        if (h) {
            NSMutableArray *keys = [[h allKeys] mutableCopy];
            for (NSString *key in keys) {
                [request setValue:[h objectForKey:key] forHTTPHeaderField:key];
            }
        }
    };

    addHeaders(params);
    addHeaders(headers);

    return request;
}

-(void)httpRequest:(int)reqType
                  :(NSString *)url
                  :(NSString *)httpMethod
                  :(NSDictionary *)params
                  :(NSDictionary *)headers
                  :(NSData *)data
   completionBlock:(void (^)(NSArray *data, NSError *error)) callback {

    NSMutableURLRequest *request = [self buildRequest:url :httpMethod :params :headers :data];

    switch (reqType) {
        case SYNC: {
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:&error];
            if (!error) {
                NSLog(@"data -- %@", [self parseResponse:data :error]);
                callback([self parseResponse:data :error], nil);
            } else {
                callback(nil, error);
            }
        }
            break;
        case ASYNC:
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       if (!error) {
                                           NSLog(@"no error");
                                           callback([self parseResponse:data :error], nil);
                                       } else {
                                           NSLog(@"error");
                                           callback(nil, error);
                                       }
                                       
                                   }];
            break;
    }
}

@end
