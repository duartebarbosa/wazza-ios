//
//  ImageInfo.m
//  SDK
//
//  Created by Joao Vasques on 21/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo

-(id)initWithData:(NSString *)name :(NSString *)url{
    self = [super init];
    self.name = name;
    self.url = url;
    return self;
}

@end
