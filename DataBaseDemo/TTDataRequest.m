//
//  TTDataRequest.m
//  DataBaseDemo
//
//  Created by wjc on 2017/4/13.
//  Copyright © 2017年 CityFire. All rights reserved.
//

#import "TTDataRequest.h"
#import "CommonCookieAuth.h"

@implementation TTDataRequest

// 短视频收藏云同步
+ (void)CloudSyncCollectVideosWithIds:(NSArray<NSNumber *> *)ids success:(void (^)())success failure:(void (^)(NSInteger code, NSString *message, NSString *failIds, NSInteger failNum))failure {
    NSMutableArray *idStrings = [@[] mutableCopy];
    for (NSNumber *idNum in ids) {
        NSString *idString = [NSString stringWithFormat:@"%ld", (long)[idNum integerValue]];
        [idStrings addObject:idString];
    }
    NSString *param = [idStrings componentsJoinedByString:@","];
//    NSDictionary *params = @{@"ids": param};
//    NSString *cookieString = [CommonCookieAuth getUserAuthCookiesString];
//    [TTHttpManager postWithUrl:tt_collect_video_url parameters:params cookies:cookieString block:^(NSDictionary *resDictionary, NSError *error) {
    NSDictionary *resDictionary;
    NSError *error;
        if (error) {
            if (failure) {
                failure(-1, error.localizedDescription, param, ids.count);
            }
        }
        else {
            NSInteger failNum = [resDictionary[@"data"][@"fail_num"] integerValue];
            NSString *failIds = resDictionary[@"data"][@"fail_ids"];
            if (failNum > 0 && failIds) {
                failure(-1, @"", failIds, failNum);
            } else {
                success();
            }
        }
//    }];
}

// 影片收藏云同步
+ (void)CloudSyncCollectMoviesWithIds:(NSArray<NSNumber *> *)ids success:(void (^)())success failure:(void (^)(NSInteger code, NSString *message, NSString *failIds, NSInteger failNum))failure {
    NSMutableArray *idStrings = [@[] mutableCopy];
    for (NSNumber *idNum in ids) {
        NSString *idString = [NSString stringWithFormat:@"%ld", (long)[idNum integerValue]];
        [idStrings addObject:idString];
    }
    NSString *param = [idStrings componentsJoinedByString:@","];
//    NSDictionary *params = @{@"ids": param};
//    NSString *cookieString = [CommonCookieAuth getUserAuthCookiesString];
//    [TTHttpManager postWithUrl:tt_collect_movie_url parameters:params cookies:cookieString block:^(NSDictionary *resDictionary, NSError *error) {
    NSDictionary *resDictionary;
    NSError *error;
        if (error) {
            if (failure) {
                failure(-1, error.localizedDescription, param, ids.count);
            }
        }
        else {
            NSInteger failNum = [resDictionary[@"data"][@"fail_num"] integerValue];
            NSString *failIds = resDictionary[@"data"][@"fail_ids"];
            if (failNum > 0 && failIds) {
                failure(-1, @"", failIds, failNum);
            } else {
                success();
            }
        }
//    }];
}


@end
