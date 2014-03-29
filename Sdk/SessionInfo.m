//
//  SessionInfo.m
//  Sdk
//
//  Created by Joao Vasques on 28/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import "SessionInfo.h"

@implementation SessionInfo

-(id)initWithoutLocation: (NSString *)userId :(NSDate *)start {
    self = [super init];

    if (self) {
        self.userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.startTime = [NSDate date];
    }
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.userId = [decoder decodeObjectForKey:@"userId"];
    self.startTime = [decoder decodeObjectForKey:@"startTime"];
    self.sessionLenght = [decoder decodeDoubleForKey:@"sessionLength"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeDouble:self.sessionLenght forKey:@"sessionLenght"];
}

-(NSDictionary *)toJson {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:self.userId forKey:@"userId"];
    [json setObject:self.startTime forKey:@"startTime"];
    [json setObject:[[NSNumber alloc] initWithDouble:self.sessionLenght] forKey:@"sessionLenght"];
    return json;
}

@end
