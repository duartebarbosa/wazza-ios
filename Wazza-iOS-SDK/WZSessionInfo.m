//
//  WZSessionInfo.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import "WZSessionInfo.h"
#import "WZDeviceInfo.h"
#import "WZSecurityService.h"

@interface WZSessionInfo ()

@property(nonatomic, strong) WZSecurityService *securityService;

@end

@implementation WZSessionInfo

-(id)initSessionInfo:(NSString *)userId {
    self = [super init];
    
    if (self) {
        self.userId = userId;
        self.startTime = [NSDate date];
        self.endTime = [NSDate date];
        self.location = nil;
        self.device = [[WZDeviceInfo alloc] initDeviceInfo];
        self.securityService = [[WZSecurityService alloc] init];
        self.purchases = [[NSMutableArray alloc] init];
        self.sessionHash = [self generateHash];
    }
    
    return self;
}

-(void)addPurchaseId:(NSString *)pId {
    [self.purchases addObject:pId];
}

-(void)updateLocationInfo:(double)latitude :(double)longitude {
    self.location = [[WZLocationInfo alloc] initWithLocationData:latitude :longitude];
}

-(NSString *)generateHash {
    NSMutableDictionary *j = [[NSMutableDictionary alloc] init];
    [j setObject:self.userId forKey:@"userId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [j setObject:[dateFormatter stringFromDate:self.startTime] forKey:@"startTime"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:j
                                                       options:0
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [self.securityService hashContent:jsonString];
    }
}

-(NSDictionary *)toJson {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:self.userId forKey:@"userId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [json setObject:[dateFormatter stringFromDate:self.startTime] forKey:@"startTime"];
    [json setObject:[dateFormatter stringFromDate:self.endTime] forKey:@"endTime"];
    [json setObject:self.sessionHash forKey:@"hash"];
    
    if (self.location != nil) {
        [json setObject:[[NSNumber alloc] initWithDouble:self.location.latitude] forKey:@"latitude"];
        [json setObject:[[NSNumber alloc] initWithDouble:self.location.longitude] forKey:@"longitude"];
    }
    
    if (self.device != nil) {
        [json setObject:[self.device toJson] forKey:@"deviceInfo"];
    }
    
    ([self.purchases count] > 0) ? [json setObject:self.purchases forKey:@"purchases"] : [json setObject:@[] forKey:@"purchases"];
    
    return json;
}

-(void)setEndDate {
    self.endTime = [NSDate date];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userId = [decoder decodeObjectForKey:@"userId"];
    self.sessionHash = [decoder decodeObjectForKey:@"sessionHash"];
    self.startTime = [decoder decodeObjectForKey:@"startTime"];
    self.endTime = [decoder decodeObjectForKey:@"endTime"];
    self.device = [decoder decodeObjectForKey:@"device"];
    self.sessionHash = [decoder decodeObjectForKey:@"hash"];
    self.purchases = [decoder decodeObjectForKey:@"purchases"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.sessionHash forKey:@"sessionHash"];
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.endTime forKey:@"endTime"];
    [encoder encodeObject:self.device forKey:@"device"];
    [encoder encodeObject:self.sessionHash forKey:@"hash"];
    [encoder encodeObject:self.purchases forKey:@"purchases"];
}

@end
