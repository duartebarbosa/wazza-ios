//
//  Item.h
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageInfo.h"
#import "Currency.h"
#import <StoreKit/StoreKit.h>

@interface Item : NSObject <NSCoding>

@property(nonatomic, retain) NSString *_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) ImageInfo *image;
@property(nonatomic, retain) Currency *currency;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
