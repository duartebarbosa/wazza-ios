//
//  Item.m
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "Item.h"
#import "ImageInfo.h"
#import "Currency.h"

@implementation Item

-(id)initFromJson: (NSDictionary *)json {
    self = [super init];
    
    self.title = [json valueForKey:@"name"];
    self.description = [json valueForKey:@"description"];
    
    NSString *imageName = [[json valueForKey:@"imageInfo"] valueForKey:@"name"];
    NSString *imageUrl = [[json valueForKey:@"imageInfo"] valueForKey:@"url"];
    self.imageInfo = [[ImageInfo alloc] initWithData:imageName :imageUrl];
    
    int currencyType = [[[json valueForKey:@"currency"] valueForKey:@"typeOf"] integerValue];
    double value = [[[json valueForKey:@"currency"] valueForKey:@"value"] doubleValue];
    NSString *currency = [[json valueForKey:@"currency"] valueForKey:@"virtualCurrency"];
    
    self.currency = [[Currency alloc] initWithData:currencyType :value :currency];
    return self;
}


@end
