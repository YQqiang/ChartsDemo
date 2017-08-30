//
//  UIColor+Util.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;


/** 线图 柱状图 配色方案 根据图表中出现的颜色数量选择优先级*/
+ (UIColor *)barPriorityAColor;
+ (UIColor *)barPriorityBColor;
+ (UIColor *)linePriorityAColor;
+ (UIColor *)linePriorityBColor;
+ (UIColor *)linePriorityCColor;

@end
