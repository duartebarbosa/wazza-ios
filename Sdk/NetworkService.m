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

-(void)httpRequest:(int)reqType
                  :(NSString *)url
                  :(NSString *)httpMethod
                  :(NSDictionary *)params
   completionBlock:(void (^)(NSArray *data, NSError *error)) callback {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self escapeURL:url]]];
    
    switch (reqType) {
        case SYNC: {
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:&error];
            if (!error) {
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
