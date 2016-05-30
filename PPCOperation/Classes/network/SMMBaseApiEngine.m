//
//  SMMApiEngine.m
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "SMMBaseApiEngine.h"
#import "SMMApiRequest.h"
#import "SMMApiResponse.h"
#import "SMMRuntime.h"
#import "NSData+SMMEncrypt.h"
#import <AFNetworking.h>
@implementation SMMBaseApiEngine
{
    //  url请求对象
    __strong NSMutableURLRequest *_request;
    //  访问路径
    __strong NSString *_baseUrl;
    //  加密串
    __strong NSString *_secretKey;
    //  预编译ID
    __strong NSString *_sessionId;
}

// 初始化
- (instancetype)initWithBaseUrl:(NSString *)baseUrl secretKey:(NSString *)secretKey
{
    self = [super init];
    if (self)
    {
        _secretKey = secretKey;
        _baseUrl = baseUrl;
    }
    return self;
}

// 数据流方式请求 WebService
- (void)requestService:(NSString *)serviceName
            parameters:(NSDictionary *)parameters
             onSuccess:(void (^)(NSDictionary *))successHandler
             onFailure:(void (^)(NSError *))failureHandler
{
    [self initRequestWithServiceName:serviceName parameters:parameters];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:_request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                failureHandler(error);
            });
        }
        else
        {
            NSHTTPURLResponse *httpReponse = (NSHTTPURLResponse *)response;
            if (httpReponse.statusCode == 200)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    successHandler(responseObject[@"content"]);
                });
            }
            else
            {
                NSLog(@"httpReponse:%@, error: %@", response, error);
            }
        }
    }];
    [dataTask resume];
}

// 初始化request
- (void)initRequestWithServiceName:(NSString *)name parameters:(NSDictionary *)parameters
{
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_baseUrl]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                   timeoutInterval:5.0f];
    _request.HTTPMethod = @"POST";
    SMMApiRequest *serviceRequest = [self generateServiceRequestWithServiceName:name
                                                                     parameters:parameters];
    [_request setHTTPBody:[self encodeRequest:serviceRequest]];
}

// 预准备
- (void)prepareOnSuccess:(void (^)(void))successHandler
               onFailure:(void (^)(NSError *))failureHandler
{
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *json)
    {
        _sessionId = json[@"session_id"];
        successHandler();
    };
    
    [self requestService:@"api.prepare" parameters:@{} onSuccess:onSuccess onFailure:failureHandler];
}

#pragma mark - Private Methods
// 封装成自定义request
- (SMMApiRequest *)generateServiceRequestWithServiceName:(NSString *)serviceName
                                                      parameters:(NSDictionary *)parameters
{
    SMMApiRequest *request = [[SMMApiRequest alloc] init];
    SMMRuntime *runtime = [SMMRuntime sharedManager];
    request.serviceName = serviceName;
    request.os = runtime.os;
    request.osVersion = runtime.osVersion;
    request.appName = runtime.appName;
    request.appVersion = runtime.appVersion;
    request.udid = runtime.udid;
    request.params = parameters;
    request.sessionId = _sessionId;
    
    return request;
}

// 编码请求
- (NSData *)encodeRequest:(SMMApiRequest *)request
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in request.params.allKeys)
    {
        id value = request.params[key];
        if ([value isKindOfClass:[NSData class]])
        {
            NSData *data = value;
            params[key] = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
        else
        {
            params[key] = value;
        }
    }
    
    NSDictionary *jsonObject = @{
                                 @"service_name" : request.serviceName,
                                 @"os" : request.os,
                                 @"os_version" : request.osVersion,
                                 @"app_name" : request.appName,
                                 @"app_version" : request.appVersion,
                                 @"udid" : request.udid,
                                 @"params" : params
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    if (_secretKey != nil)
    {
        data = [data sdk_AESEncryptWithKey:_secretKey];
    }
    
    return data;
}

// 解码应答
- (SMMApiResponse *)decodeResponse:(NSData *)responseData
{
    NSData *data = responseData;
    
    if (_secretKey != nil)
    {
        data = [responseData sdk_AESDecryptWithKey:_secretKey];
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    SMMApiResponse *response = [[SMMApiResponse alloc] init];
    response.status = (SDK_ApiServiceResponseStatus)[json[@"status"] intValue];
    response.errorMessage = json[@"error_message"];
    response.content = json[@"content"];
    
    return response;
}
@end
