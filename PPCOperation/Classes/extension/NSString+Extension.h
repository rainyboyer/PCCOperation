//
//  NSString+Extension.h
//  Pods
//
//  Created by Apple on 7/7/16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

//没有数字的随机字符串
+ (instancetype)randomStringWithoutNumber;

//包含数字的随机字符串
+ (instancetype)randomStringWithNumber;

//url encode
+ (instancetype)encodeString:(NSString *)unencodedString;

//md5 encode
+ (instancetype)md5String:(NSString *)string;
@end
