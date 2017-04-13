//
//  NSString+Util.h
//  iKanKan
//
//  Created by kankan on 16/1/6.
//  Copyright © 2016年 Nesound Kankan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(Util)

+ (NSString *)encodeUrlString:(NSString*)unencodedString;
+ (NSString *)decodeUrlString:(NSString*)encodedString;

+ (NSString *)formatStringWithNumber:(long long)number;
+ (NSString *)realFormatStringWithNumber:(long long)number;


/**
 *  根据字体计算最合适的尺寸
 *
 *  @param font 字体
 *  @param size 尺寸
 *
 *  @return 最合适的尺寸
 */
- (CGSize)resizeWithFont:(UIFont *)font adjustSize:(CGSize)size;

/**
 *  根据字体计算最合适的尺寸
 *
 *  @param font 字体
 *  @param size 尺寸
 *  @param lineSpace 行高
 *
 *  @return 最合适的尺寸
 */
- (CGSize)resizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace adjustSize:(CGSize)size;

/**
 *  获取文字尺寸
 *
 *  @param textFont <#textFont description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)getTextSizeWithtextFont:(UIFont*)textFont;


/**
 *  判断字符串是否为空 （nil 与 '' 与 NSNull 与 空白字符）
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isBlank:(NSString *)string;

/**
 *  从字符串转化成 NSDate
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 */
- (NSDate *)transToNSDate:(NSString*)format;

/**
 *  判断是否为有效邮箱
 *
 *  @param email 邮箱地址
 *
 *  @return 是否有效
 */
+ (BOOL) validateEmail:(NSString *)email;
/**
 *  判断是否为有效手机
 *
 *  @param mobile 手机号码
 *
 *  @return 是否有效
 */
+ (BOOL) validateMobile:(NSString *)mobile;



/**
 *  是否包含特殊字符
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 *  仅限数字
 */
- (BOOL)isHasSpecimalWord:(NSString *)string;

- (BOOL)isNumber:(NSString *)string;

/**
 *  校验身高
 *
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)validateHeight:(NSString *)height;

/**
 *  校验体重
 *
 *  @param weight <#weight description#>
 *
 *  @return <#return value description#>
 */
- (BOOL) validateWeight:(NSString *)weight;

/**
 *  格式化电话号码
 *
 *  @param cellPhone 电话号码
 *
 *  @return 格式化后的电话号码
 */
- (NSString *)formatCellphone:(NSString *)cellPhone;



/**
 *  校验绑定 密码合法性
 *
 *  @param pass pass description
 *
 *  @return <#return value description#>
 */
- (BOOL)validatePassword:(NSString *)pass;

/**
 * 计算昵称长度 中英文处理方式有区别
 *
 */
- (int)calNickNameLength;

/** 截取字符串至指定长度(包含中文和英文字符混合的处理) */
- (NSString *)substringToLength:(int)length;

+ (NSString *) htmlEntityDecode:(NSString *) string;

//URLEncode
+ (NSString *)encodeString:(NSString*)unencodedString;
//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString;

/** 去除字符串中的空格 */
- (NSString *)deleteSpace;
/**
 *  去除字符串首尾空格
 *
 */
- (NSString *)deleteHeadAndTrialSpaceOfString;

// 把秒数转为时、分、秒
+ (NSString *)getDateStringWithInterval:(NSInteger)interval;
// 把秒数转为分、秒
+ (NSString *)getTimeStringWithInterval:(NSInteger)interval;

//获取字符串长度
+ (NSInteger)GetStringCharSize:(NSString*)argString;

// 把以01:03:06格式的字符串转换成时间戳
+ (NSUInteger)getTimeWithString:(NSString *)timeString;
// 把时间戳转换特殊格式字符串
+ (NSString *)timeStringWithTimeLength:(NSUInteger)interval;

@end
