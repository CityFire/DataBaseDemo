//
//  TTDataRequest.h
//  DataBaseDemo
//
//  Created by wjc on 2017/4/13.
//  Copyright © 2017年 CityFire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDataRequest : NSObject

/** 短视频收藏云同步 */
+ (void)CloudSyncCollectVideosWithIds:(NSArray<NSNumber *> *)ids success:(void (^)())success failure:(void (^)(NSInteger code, NSString *message, NSString *failIds, NSInteger failNum))failure;
/** 影片收藏云同步 */
+ (void)CloudSyncCollectMoviesWithIds:(NSArray<NSNumber *> *)ids success:(void (^)())success failure:(void (^)(NSInteger code, NSString *message, NSString *failIds, NSInteger failNum))failure;

@end
