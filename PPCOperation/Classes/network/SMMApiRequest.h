//
//  SMMApiRequest.h
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMApiRequest : NSObject

// 操作系统
@property (nonatomic, strong) NSString *os;
// 操作系统版本
@property (nonatomic, strong) NSString *osVersion;
// 应用名称
@property (nonatomic, strong) NSString *appName;
// 应用版本
@property (nonatomic, strong) NSString *appVersion;
// 设备UDID
@property (nonatomic, strong) NSString *udid;
// Session ID
@property (nonatomic, strong) NSString *sessionId;
// 请求服务名
@property (nonatomic, strong) NSString *serviceName;
// 请求参数
@property (nonatomic, strong) NSDictionary *params;
@end
