//
//  SMMURIActionHandlerProtocol.h
//  SocialMediaMonitor
//
//  Created by Kratos on 15/10/26.
//  Copyright © 2015年 wendy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMMURIActionHandlerProtocol <NSObject>

@optional
// 所支持的Scheme
- (NSString *)supportedScheme;

// 所支持的Host
- (NSString *)supportedHost;

// 处理URI
- (BOOL)handleUri:(NSURL *)uri;

@end
