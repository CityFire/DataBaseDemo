//
//  TTCloudSyncManager.h
//  TTKanKan
//
//  Created by wjc on 2017/1/19.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kTTKKVideoSyncDidSuccessNotification;  // 短视频云同步成功通知
extern NSString *const kTTKKMovieSyncDidSuccessNotification;  // 长视频云同步成功通知

@interface TTCloudSyncManager : NSObject

// 串行的异步线程，收藏专用
@property (nonatomic, strong) dispatch_queue_t cloudFavoriteSerialQueue;

@property (nonatomic, strong) dispatch_group_t cloudManagerGroup;

#pragma mark - 单例

+ (instancetype)shareInstance;

@end
