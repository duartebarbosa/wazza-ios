//
//  ImageInfo.m
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = [decoder decodeObjectForKey:@"name"];
    self.url = [decoder decodeObjectForKey:@"url"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.url forKey:@"url"];
}

@end
