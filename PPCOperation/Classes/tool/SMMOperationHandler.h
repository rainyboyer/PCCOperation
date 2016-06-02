//
//  SMMDownloadHandler.h
//  TestHtmlCSSJS
//
//  Created by Apple on 5/17/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SMMOperationHandler;
@protocol SMMOperationHandlerDelegate<NSObject>
- (void)operationHandler:(SMMOperationHandler *)handler version:(NSString *)version key:(NSString *)key;
- (void)downloadFailWithOperationHandler:(SMMOperationHandler *)handler fileUrl:(NSURL *)url version:(NSString *)version key:(NSString *)key;
@end

@interface SMMOperationHandler : NSObject

//  将json内容转换为多条url，如：http://192.168.172.200/tpl/appHtml/version/html.json
- (void)getFileDictionaryWithUrl:(NSURL *)url version:(NSString *)version key:(NSString *)key;

@property (nonatomic, weak) id <SMMOperationHandlerDelegate>delegate;
@end
