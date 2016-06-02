//
//  NSData+SMMEncrypt.h
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SMMEncrypt)

- (NSData *)sdk_AESEncryptWithKey:(NSString *)key;

- (NSData *)sdk_AESDecryptWithKey:(NSString *)key;
@end
