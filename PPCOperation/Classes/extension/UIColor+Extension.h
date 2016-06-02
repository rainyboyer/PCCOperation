//
//  UIColor+Extension.h
//  PPCOperation
//
//  Created by Apple on 5/31/16.
//  Copyright © 2016 pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 *  通过16进制颜色通道返回颜色
 *
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
