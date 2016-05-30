//
//  SMMApiResponse.h
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , SDK_ApiServiceResponseStatus)
{
    // 请求成功
    SMMApiServiceResponseStatusSuccess = 0,
    // 请求失败或有误
    SMMApiServiceResponseStatusFailure = 1
};


@interface SMMApiResponse : NSObject

// 应答状态
@property (nonatomic, assign) SDK_ApiServiceResponseStatus status;
// 错误消息，如无错，则为nil
@property (nonatomic, strong) NSString *errorMessage;
// 应答内容
@property (nonatomic, strong) NSDictionary *content;
@end
