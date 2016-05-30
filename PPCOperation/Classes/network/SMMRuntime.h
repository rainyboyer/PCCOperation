//
//  SMMRuntime.h
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMMSharedBaseClass.h"
@interface SMMRuntime : SMMSharedBaseClass

// 操作系统
@property (nonatomic, strong, readonly) NSString *os;

// 操作系统版本
@property (nonatomic, strong, readonly) NSString *osVersion;

// 应用名
@property (nonatomic, strong, readonly) NSString *appName;

// 应用版本
@property (nonatomic, strong, readonly) NSString *appVersion;

// 设备ID
@property (nonatomic, strong, readonly) NSString *udid;

// 缓存目录
@property(nonatomic, strong, readonly) NSString *cacheDirPath;


@end
