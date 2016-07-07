//
//  SMMPushWebPageAction.m
//  SocialMediaMonitor
//
//  Created by Apple on 6/14/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

#import "SMMPushWebPageAction.h"
#import "SMMUriActionEngine.h"

@implementation SMMPushWebPageAction

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
    return @"web";
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
//    [UIApplication sharedApplication] openURL:@""
    return YES;
}
@end
