//
//  ImageInfo.h
//  SDK
//
//  Created by Joao Vasques on 21/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *url;

-(id)initWithData:(NSString *)name :(NSString *)url;

@end
