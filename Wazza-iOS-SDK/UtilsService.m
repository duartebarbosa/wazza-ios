//
//  UtilsService.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 19/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "UtilsService.h"

@implementation UtilsService

+(NSString *)createStringFromJSON:(NSDictionary *)dic {
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

@end
