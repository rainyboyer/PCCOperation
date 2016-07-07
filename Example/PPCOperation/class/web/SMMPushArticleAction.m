//
//  SMMPushArticleAction.m
//  SocialMediaMonitor
//
//  Created by Apple on 6/7/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

#import "SMMPushArticleAction.h"
#import "SMMUriActionEngine.h"
#import "PPCLoadWebVC.h"

@implementation SMMPushArticleAction


- (void)load
{
    [[SMMUriActionEngine sharedEngine] register:self];
}

- (NSString *)supportedHost
{
    return @"article";
}

- (NSString *)supportedScheme
{
    return @"local";
}

- (BOOL)handleUri:(NSURL *)uri
{
    NSString *query = uri.query;
    NSInteger index = 5;
    NSString *dataString = [uri.query substringWithRange:NSMakeRange(index, query.length-index)];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:dataString options:0];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    NSLog(@"dic: %@", dic);
    PPCLoadWebVC *webVC = [[PPCLoadWebVC alloc]initWithFilePath:dic[@"appjson"][@"file"] sourceDocument:@"Faxian"];
    webVC.webJson = dic[@"webjson"];

    UINavigationController *currentVC = [self getCurrentVC];

    [currentVC pushViewController:webVC animated:YES];

    return YES;
}

#pragma mark - Private Methods
//  获取当前显示的控制器
- (UINavigationController *)getCurrentVC
{
    UINavigationController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UINavigationController class]])
        result = nextResponder;
    else
        result = (UINavigationController *)window.rootViewController;
    
    return result;
}

@end
