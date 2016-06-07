//
//  PPCDefine.h
//  TestHtmlCSSJS
//
//  Created by Apple on 5/30/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DownloadUrl @"http://124.172.184.212:8009/tpl/appHtml"
#define ApiUrl @"http://124.172.184.212:8009/index.php?g=appApi&m=mapi&a=index"
#define HtmlDocument @"appHtml"

/**
 *  NSLog重定义
 */
#define NSLog(format, ...) do { \
fprintf(stderr, "<%s : %d> %s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__); \
(NSLog)((format), ##__VA_ARGS__); \
fprintf(stderr, "-------\n"); \
} while (0)

/**
 *  单例宏定义
 */
// .h文件
#define PPCSingletonH(suffix) + (instancetype)shared##suffix;
//.m文件
#define PPCSingletonM(suffix) \
static id _instance = nil;\
+ (instancetype)shared##suffix \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}
@interface PPCDefine : NSObject

@end
