//
//  SMMUriActionHandlerProtocol.m
//  SocialMediaMonitor
//
//  Created by Kratos on 15/10/26.
//  Copyright © 2015年 wendy. All rights reserved.
//

#import "SMMUriActionEngine.h"
#import "SMMURIActionHandlerProtocol.h"

@interface SMMUriActionEngine ()

@end


@implementation SMMUriActionEngine
{
    NSMutableDictionary *_mapping;

}

PPCSingletonM(Engine)
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)register:(id <SMMURIActionHandlerProtocol>)handler
{
    NSString *key = [self generateKeyWithHandler:handler];
    _mapping[key] = handler;
}

- (BOOL)handle:(NSURL *)uri
{
    NSString *key = [self generateKeyWithUri:uri];
    
    id <SMMURIActionHandlerProtocol> handler = _mapping[key];
    if (handler == nil)
    {
        return NO;
    }
    
    return [handler handleUri:uri];
}

- (NSString *)generateKeyWithHandler:(id <SMMURIActionHandlerProtocol>)handler
{
    return [NSString stringWithFormat:@"%@_%@", handler.supportedScheme, handler.supportedHost];
}

- (NSString *)generateKeyWithUri:(NSURL *)uri
{
    return [NSString stringWithFormat:@"%@_%@", uri.scheme, uri.host];
}

@end
