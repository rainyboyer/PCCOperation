//
//  SMMUriActionHandlerProtocol.h
//  SocialMediaMonitor
//
//  Created by Kratos on 15/10/26.
//  Copyright © 2015年 wendy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPCDefine.h"
@protocol SMMURIActionHandlerProtocol;

@interface SMMUriActionEngine :NSObject

PPCSingletonH(Engine)
// 注册处理器
- (void)register:(id <SMMURIActionHandlerProtocol>)handler;

//处理URI
- (BOOL)handle:(NSURL *)uri;

@end
