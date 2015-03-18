//
//  WZSecurityService.h
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZSecurityService : NSObject

- (NSData *)AES256EncryptWithKey:(NSString *)key :(NSString *)content;

- (NSData *)AES256DecryptWithKey:(NSString *)key :(NSString *)content;

- (NSString *)hashContent:(NSString *)input;

@end
