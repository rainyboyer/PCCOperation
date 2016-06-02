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

//A better version of NSLog
#define NSLog(format, ...) do { \
fprintf(stderr, "<%s : %d> %s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__); \
(NSLog)((format), ##__VA_ARGS__); \
fprintf(stderr, "-------\n"); \
} while (0)
@interface PPCDefine : NSObject

@end
