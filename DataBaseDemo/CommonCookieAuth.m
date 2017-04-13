//
//  CommonCookieAuth.m
//  TTKanKan
//
//  Created by wjc on 2017/2/7.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "CommonCookieAuth.h"

@implementation CommonCookieAuth

+ (NSString *)getUserAuthCookiesString {
    NSString *cookies = @"";
    if (YES) {
        cookies = [NSString stringWithFormat:@"userid=%@;sessionid=%@;operationid=%d", @"userID", @"sessionID", 26];
        if (@"sessionID" == nil || [@"sessionID" isEqualToString:@""]) {
            NSLog(@"model.sessionID 为空，请求数据的话可能返回未登录");
        }
        NSAssert(@"sessionID" != nil || ![@"sessionID" isEqualToString:@""], @"model.sessionID 为空，请求数据的话可能返回未登录");
    }
    return cookies;
}

@end
