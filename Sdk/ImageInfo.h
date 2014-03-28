//
//  ImageInfo.h
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject <NSCoding>

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *url;

-(id)initWithData:(NSString *)name :(NSString *)url;
-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;

@end
