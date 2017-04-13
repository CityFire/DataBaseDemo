//
//  NSString+Util.m
//  iKanKan
//
//  Created by kankan on 16/1/6.
//  Copyright © 2016年 Nesound Kankan Inc. All rights reserved.
//

#import "NSString+Util.h"
#define NUMBERS @"0123456789\n"

@implementation NSString(Util)

+ (NSString*)encodeUrlString:(NSString*)unencodedString {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    return encodedString;
}

//URLDEcode
+ (NSString *)decodeUrlString:(NSString*)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
#pragma clang diagnostic pop
    return decodedString;
}



+ (NSString *)formatStringWithNumber:(long long)number
{
    NSString *string = nil;
    // 三种单位，亿 万 千
    if (number < 1000) {
        string = @"不到1000";
    }
    else {
        string = [self realFormatStringWithNumber:number];
    }
    return string;
}

+ (NSString *)realFormatStringWithNumber:(long long)number
{
    NSString *string = nil;
    // 三种单位，亿 万 千
    if(number >= 100000000)
    {
        string = [NSString stringWithFormat:@"%.1f亿", number / 100000000.0];
    }
    else if (number >= 10000)
    {
        string = [NSString stringWithFormat:@"%lld万", number / 10000];
    }
    else
    {
        string = [NSString stringWithFormat:@"%lld", number];
    }
    
    return string;
}

- (CGSize)resizeWithFont:(UIFont *)font adjustSize:(CGSize)size
{
    //注意：这里的字体要和控件的字体保持一致
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    //处理有换行时的宽，
    NSString *text = self;
    if (size.width > 10000) {
        NSArray *texts = [text componentsSeparatedByString:@"\r\n"];
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\r"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\n"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\f"];
        }
        if (texts.count>0) {
            text = texts[0];
            for (int i=1; i<texts.count; i++) {
                NSString *str = [texts objectAtIndex:i];
                if (str.length>text.length) {
                    text = str;
                }
            }
        }
    }
    CGRect reFrame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return reFrame.size;
}

- (CGSize)resizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace adjustSize:(CGSize)size
{
    //注意：这里的字体要和控件的字体保持一致
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    attrs[NSParagraphStyleAttributeName] = paragraphStyle;
    //处理有换行时的宽，
    NSString *text = self;
    if (size.width > 10000) {
        NSArray *texts = [text componentsSeparatedByString:@"\r\n"];
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\r"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\n"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\f"];
        }
        if (texts.count>0) {
            text = texts[0];
            for (int i=1; i<texts.count; i++) {
                NSString *str = [texts objectAtIndex:i];
                if (str.length>text.length) {
                    text = str;
                }
            }
        }
    }
    CGRect reFrame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return reFrame.size;
}

- (CGSize)getTextSizeWithtextFont:(UIFont*)textFont{
    return [self boundingRectWithSize:CGSizeMake(NSIntegerMax, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:nil].size;
}

- (CGSize)resizeWithAttr:(UIFont *)font adjustSize:(CGSize)size
{
    //注意：这里的字体要和控件的字体保持一致
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    CGRect reFrame = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return reFrame.size;
}

+ (BOOL)isBlank:(NSString *)string{
    if (string == nil || string == NULL||[string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ( ( [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
        ) {
        return YES;
    }
    
    return NO;
}

/**
 *  将日期字符串转为 NSDate类型
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 */
- (NSDate *)transToNSDate:(NSString*)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:self];
    return date;
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**
 *  是否包含特殊字符
 *
 *  @param string <#string description#>
 *
 *  @return return value description
 */
- (BOOL)isHasSpecimalWord:(NSString *)string {
    NSString *regex = @"^.*[&#%￥/\\^\\$\\^'\\:`\\-\\+\\|\\]\\[\\{\\}\\<\\>=\\*].*$";
    NSPredicate *specialTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [specialTest evaluateWithObject:string];
    
}

- (BOOL)isNumber:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
        return NO;
    }
    return YES;
}

- (BOOL)validateHeight:(NSString *)height {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *heightTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [heightTest evaluateWithObject:height];
}

- (BOOL) validateWeight:(NSString *)weight {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *weightTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [weightTest evaluateWithObject:weight];
}

- (NSString *)formatCellphone:(NSString *)cellPhone{
    NSMutableString *string=[NSMutableString stringWithString:cellPhone];
    if (cellPhone.length<=11&&cellPhone.length>7) {
        [string insertString:@" " atIndex:3];
        [string insertString:@" " atIndex:8];
    }
    else if (cellPhone.length<=7&&cellPhone.length>3){
        [string insertString:@" " atIndex:3];
    }
    else{
        
    }
    NSLog(@"格式化的电话号码：%@",string);
    return string;
}

- (BOOL)validatePassword:(NSString *)pass {
    NSString *regex = @"^.{6,16}$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [passTest evaluateWithObject:pass];
}

- (int)calNickNameLength {
    int length = 0;
    if (self.length > 0) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSUInteger number = [[NSString stringWithString:self] lengthOfBytesUsingEncoding:enc];
        return (int)number;
    }
    return length;
}

- (NSString *)substringToLength:(int)length {
    int total = 0;
    NSMutableString *string = [NSMutableString string];
    
    if (self.length > 0) {
        for (int i = 0; i < self.length; i++) {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[self substringWithRange:range];
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSUInteger number = [[NSString stringWithString:subString] lengthOfBytesUsingEncoding:enc];
            total += number;
            if (total > length ) {
                return string;
            }
            
            [string appendString:subString];
        }
    }
    return string;
}

+ (NSInteger)GetStringCharSize:(NSString *)argString
{
    NSInteger strlength = 0;
    char* p = (char*)[argString cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i<[argString lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else{
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (NSString *) htmlEntityDecode:(NSString *) string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return string;
    
}


//URLEncode
+ (NSString*)encodeString:(NSString*)unencodedString{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    return encodedString;
}

//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
#pragma clang diagnostic pop
    return decodedString;
}

- (NSString *)deleteSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)deleteHeadAndTrialSpaceOfString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)getDateStringWithInterval:(NSInteger)interval
{
    NSInteger seconds = interval % 60;
    NSInteger minutes = (interval / 60) % 60;
    NSInteger hours = interval / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
    
}

+ (NSString *)getTimeStringWithInterval:(NSInteger)interval {
    NSInteger seconds = interval % 60;
    NSInteger minutes = (interval / 60) % 60;
    NSInteger hours = interval / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
    }
    
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes,(long)seconds];
    
}

+ (NSString *)timeStringWithTimeLength:(NSUInteger)interval {
    NSInteger seconds = interval % 60;
    NSInteger minutes = (interval / 60) % 60;
    NSInteger hours = interval / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02lu:%02lu'%02lu\"", (unsigned long)hours,(unsigned long)minutes, (unsigned long)seconds];
    }
    else {
        return [NSString stringWithFormat:@"%02lu'%02lu\"", (unsigned long)(unsigned long)minutes, (unsigned long)seconds];
    }
}

+ (NSUInteger)getTimeWithString:(NSString *)timeString {
    NSInteger totalInterval = 0;
    if ([timeString rangeOfString:@":"].location != NSNotFound) {
        NSArray *timeIntervalArr = [timeString componentsSeparatedByString:@":"];
        if (timeIntervalArr.count == 3) {
            // 有时钟
            NSInteger hours = [[timeIntervalArr firstObject] integerValue];
            NSInteger minutes = MIN([[timeIntervalArr objectAtIndex:1] integerValue], 60);
            NSInteger seconds = MIN([[timeIntervalArr lastObject] integerValue], 60);
            totalInterval = hours * 3600 + minutes * 60 + seconds;
        }
        else if (timeIntervalArr.count == 2) {
            // 有分钟
            NSInteger minutes = MIN([[timeIntervalArr firstObject] integerValue], 60);
            NSInteger seconds = MIN([[timeIntervalArr lastObject] integerValue], 60);
            totalInterval = minutes * 60 + seconds;
        }
        else if (timeIntervalArr.count == 1) {
            // 只有秒钟
            totalInterval = MIN([[timeIntervalArr lastObject] integerValue], 60);
        }
        else {
            return totalInterval;
        }
    }
    return totalInterval;
}

@end
