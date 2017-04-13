//
//  CommonCookieAuth.h
//  TTKanKan
//
//  Created by wjc on 2017/2/7.
//  Copyright © 2017年 kankan. All rights reserved.
//  登录验证方式： 统一通过 http 传送cookie信息来做验证。

#import <Foundation/Foundation.h>

@interface CommonCookieAuth : NSObject
/*
 * 生成用户验证的cookies
 * userid=1006133048;sessionid=6DBA3DEC0B827FAB94374E37A561531B;operationid=27
 */
+ (NSString *)getUserAuthCookiesString;

@end
