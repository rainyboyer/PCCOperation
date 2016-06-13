//
//  SMMRuntime.m
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "SMMRuntime.h"
#import <UIKit/UIKit.h>


@implementation SMMRuntime
PPCSingletonM(Instance)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSDictionary *info = mainBundle.infoDictionary;
        _appName = info[@"CFBundleName"];
        _appVersion = info[@"CFBundleShortVersionString"];
        
        _os = [[UIDevice currentDevice] systemName];
        _osVersion = [[UIDevice currentDevice] systemVersion];
        _udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return self;
}

- (NSString *)cacheDirPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
@end
