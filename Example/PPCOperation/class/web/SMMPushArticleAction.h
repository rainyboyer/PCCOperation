//
//  SMMPushArticleAction.h
//  SocialMediaMonitor
//
//  Created by Apple on 6/7/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMMURIActionHandlerProtocol.h"

@interface SMMPushArticleAction : NSObject<SMMURIActionHandlerProtocol>

- (void)load;
@end
