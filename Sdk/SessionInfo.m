//
//  SessionInfo.m
//  Sdk
//
//  Created by Joao Vasques on 28/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import "SessionInfo.h"
#import "DeviceInfo.h"

@implementation SessionInfo

-(id)initWithoutLocation {
    self = [super init];

    if (self) {
        self.userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.startTime = [NSDate date];
        self.location = nil;
        self.device = [[DeviceInfo alloc] initDeviceInfo];
    }
    
    return self;
}

-(void)updateLocationInfo:(double)latitude :(double)longitude {
    self.location = [[LocationInfo alloc] initWithLocationData:latitude :longitude];
}

-(NSDictionary *)toJson {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:self.userId forKey:@"userId"];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.startTime
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterFullStyle];
    [json setObject:dateString forKey:@"startTime"];
    [json setObject:[[NSNumber alloc] initWithDouble:self.sessionLenght] forKey:@"sessionLenght"];
    
    if (self.location != nil) {
        [json setObject:[[NSNumber alloc] initWithDouble:self.location.latitude] forKey:@"latitude"];
        [json setObject:[[NSNumber alloc] initWithDouble:self.location.longitude] forKey:@"longitude"];
    }
    
    if (self.device != nil) {
        [json setObject:[self.device toJson] forKey:@"deviceInfo"];
    }
    
    return json;
}

-(void)calculateSessionLength {
    NSDate *now = [NSDate date];
    self.sessionLenght = [now timeIntervalSinceDate:self.startTime];
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
    
    self.device = [[DeviceInfo alloc] initWithData:
                   [decoder decodeObjectForKey:@"osName"]:
                   [decoder decodeObjectForKey:@"osVersion"]:
                   [decoder decodeObjectForKey:@"deviceModel"]];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeDouble:self.sessionLenght forKey:@"sessionLenght"];
    
    //Device Info
    [encoder encodeObject:self.device.osName forKey:@"osName"];
    [encoder encodeObject:self.device.osVersion forKey:@"osVersion"];
    [encoder encodeObject:self.device.deviceModel forKey:@"deviceModel"];
}

@end
