//
//  WZSecurityService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZSecurityService : NSObject

@property NSString *token;

-(instancetype)initService:(NSString *)token;

- (NSData *)AES256EncryptWithKey:(NSString *)key :(NSString *)content;

- (NSData *)AES256DecryptWithKey:(NSString *)key :(NSString *)content;

- (NSString *)hashContent:(NSString *)input;

@end
