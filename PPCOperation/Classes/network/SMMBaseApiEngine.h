//
//  SMMApiEngine.h
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMBaseApiEngine : NSObject

// 初始化
- (instancetype)initWithBaseUrl:(NSString *)baseUrl secretKey:(NSString *)secretKey;

// 数据流方式请求 WebService
- (void)requestService:(NSString *)serviceName
            parameters:(NSDictionary *)parameters
             onSuccess:(void (^)(NSDictionary *))successHandler
             onFailure:(void (^)(NSError *))failureHandler;

// 预准备
- (void)prepareOnSuccess:(void (^)(void))successHandler
               onFailure:(void (^)(NSError *))failureHandler;
@end
