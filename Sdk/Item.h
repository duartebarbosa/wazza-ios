//
//  Item.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageInfo.h"
#import "Currency.h"

@interface Item : NSObject

@property(nonatomic) NSString *title;
@property(nonatomic) NSString *description;
@property(nonatomic, strong) ImageInfo *imageInfo;
@property(nonatomic, strong) Currency *currency;

-(id)initFromJson: (NSDictionary *)json;

@end
