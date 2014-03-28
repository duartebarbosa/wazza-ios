//
//  Purchase.m
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "Purchase.h"
#import "LocationInfo.h"
#import "SecurityService.h"

@implementation Purchase

-(id)initWithData:(NSString *)name :(NSString *)itemId : (double)price {
    self = [self init];
    
    /**
     Purchase Id format: Hash(appName + itemID + time + device)
     **/
    NSString*(^generateID)(void) = ^NSString* {
        SecurityService *securityService = [[SecurityService alloc] init];
        NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@-%@-%@", self.applicationName, self.itemId, [self dateToString], @""];
        return [securityService hashContent:idValue];
    };
    
    self.applicationName = name;
    self.itemId = itemId;
    self.price = price;
    self.time = [NSDate date];
    self.location = Nil; //TODO
    self._id = generateID();
    return self;
}

-(NSString *)dateToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
    return[formatter stringFromDate:self.time];
}

-(NSDictionary *)toJson {
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    NSString *time = [self dateToString];
    
    [json setObject:self._id forKey:@"id"];
    [json setObject:self.applicationName forKey:@"name"];
    [json setObject:self.itemId forKey:@"itemId"];
    [json setObject:[[NSNumber alloc] initWithDouble:self.price] forKey:@"price"];
    [json setObject:time forKey:@"time"];
    
    return json;
}

@end
