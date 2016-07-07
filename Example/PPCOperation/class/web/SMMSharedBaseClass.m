//
//  SMMSharedBaseClass.m
//  TestHtmlCSSJS
//
//  Created by Apple on 5/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "SMMSharedBaseClass.h"

@implementation SMMSharedBaseClass

+ (id)sharedManager
{
    static SMMSharedBaseClass *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
