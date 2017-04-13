//
//  TTCloudSyncManager.m
//  TTKanKan
//
//  Created by wjc on 2017/1/19.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTCloudSyncManager.h"
#import "TTDataRequest.h"
#import "TTMyFavouriteDBManager.h"
#import "TTReachabilityManager.h"
#import "TTFavouriteModel.h"
#import "NSTimer+TTWeakTimer.h"

#pragma mark - Weak Strong

// weakSelf
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

// strongSelf
#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif


#define KanKanUserNotifyNameLogin @"KanKanUserNotifyNameLogin"
#define KanKanUserNotifyNameSessionldLogin @"KanKanUserNotifyNameSessionldLogin"
#define KanKanUserNotifyNameLogout @"KanKanUserNotifyNameLogout"

NSString *const kTTKKVideoSyncDidSuccessNotification = @"kTTKKVideoSyncDidSuccessNotification";  // 短视频云同步成功通知
NSString *const kTTKKMovieSyncDidSuccessNotification = @"kTTKKMovieSyncDidSuccessNotification";  // 长视频云同步成功通知
static const NSInteger RetryTimes = 60;
static const NSInteger RetryTimesMargin = 5; // 失败后重新请求直到没有失败的id 5秒一次 一共12次

typedef NS_ENUM(NSUInteger, TTCloudSyncType) {
    TTCloudSyncTypeVideo = 0,  // 视频
    TTCloudSyncTypeMovie = 1,  // 影片
};

@interface TTCloudSyncManager () {
    TTMyFavouriteDBManager *_dbManager;
    __block NSString *_videoFailIds; // 短视频失败时的id,以逗号隔开的
    __block NSString *_movieFailIds; // 长视频失败时的id,以逗号隔开的
    NSInteger _videoRequestCount;
    NSInteger _movieRequestCount;
}

@property (nonatomic, weak) NSTimer *videoTimer; // 短视频定时器

@property (nonatomic, weak) NSTimer *movieTimer; // 长视频定时器

@end

@implementation TTCloudSyncManager

static TTCloudSyncManager *sharedInstance = nil;

// app启动时初始化一次，以便登录监听云同步
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTCloudSyncManager alloc] init];
    });
}

#pragma mark - 单例

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTCloudSyncManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dbManager = [TTMyFavouriteDBManager sharedInstance];
        _videoRequestCount = 0;
        _movieRequestCount = 0;
        [self addLoginNotificationObserver];
        [self addLogoutNotificationObserver];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.videoTimer invalidate];
    [self.movieTimer invalidate];
}

#pragma mark - 通知注册

// 监听登录通知
- (void)addLoginNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kankanUserLoginNotifyCloudSyncHandle:)
                                                 name: KanKanUserNotifyNameLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kankanUserLoginNotifyCloudSyncHandle:)
                                                 name:KanKanUserNotifyNameSessionldLogin object:nil];
    [self initializationGCD];
}

- (void)addLogoutNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kankanLogoutNotifyCloudSyncHandle:)
                                                 name: KanKanUserNotifyNameLogout object:nil];
}

- (void)initializationGCD {
    _cloudFavoriteSerialQueue = dispatch_queue_create("serialFavoriteCloudQueue", DISPATCH_QUEUE_SERIAL);
    _cloudManagerGroup = dispatch_group_create();
}

#pragma mark - 通知回调

// 退出登录通知处理
- (void)kankanLogoutNotifyCloudSyncHandle:(NSNotification *)notification {
    
}

- (void)kankanUserLoginNotifyCloudSyncHandle:(NSNotification *)notification {
    if ([[TTReachabilityManager sharedInstance] getNetworkStatus] == TTNotReachable) {
        return;
    }
    // 同步收藏记录到线上
    NSDictionary *dict = notification.object;
    NSString *name = [dict valueForKey:@"name"];
    NSNumber *code = (NSNumber *)[dict valueForKey:@"code"];
    if ([code integerValue] == 0) {
        if ([name isEqualToString:KanKanUserNotifyNameLogin]) {
            // 密码登录
            if (code.intValue == 0) {
                [self syncDBDataToServer];
            }
        }
        else if ([name isEqualToString:KanKanUserNotifyNameSessionldLogin]) {
            // sessionId登录成功
            if (code.intValue == 0) {
                [self syncDBDataToServer];
            }
        }
    }
}

#pragma mark - 清除本地数据库

// 清除短视频本地数据库收藏记录
- (void)clearVideoDBData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL delSuccess = [_dbManager deleteAllFavouriteDataFromTable:[_dbManager getVideoLocalTableName]];
        if (delSuccess) {
            NSLog(@"短视频本地数据库删除成功");
        }
        else {
            NSLog(@"短视频本地数据库删除失败");
        }
    });
}

// 清除长视频本地数据库收藏记录
- (void)clearMovieDBData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL delSuccess = [_dbManager deleteAllFavouriteDataFromTable:[_dbManager getMovieLocalTableName]];
        if (delSuccess) {
            NSLog(@"长视频本地数据库删除成功");
        }
        else {
            NSLog(@"长视频本地数据库删除失败");
        }
    });
}

// 清除同步成功的短视频数据
- (void)clearSyncSuccessAndSaveFailVideoDBData:(NSArray *)successArray {
    if (successArray.count == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL delSuccess = [_dbManager deleteFavouriteNumberDataFromTable:[_dbManager getVideoLocalTableName] datas:successArray];
        if (delSuccess) {
            NSLog(@"短视频本地数据库已同步数据删除成功");
        }
        else {
            NSLog(@"短视频本地数据库已同步数据删除失败");
        }
    });
}

// 清除同步成功的长视频数据
- (void)clearSyncSuccessAndSaveFailMovieDBData:(NSArray *)successArray {
    if (successArray.count == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL delSuccess = [_dbManager deleteFavouriteNumberDataFromTable:[_dbManager getMovieLocalTableName] datas:successArray];
        if (delSuccess) {
            NSLog(@"长视频本地数据库已同步数据删除成功");
        }
        else {
            NSLog(@"长视频本地数据库已同步数据删除失败");
        }
    });
}

#pragma mark - 同步数据

- (void)syncDBDataToServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 登录 把本地记录和线上记录合并，并同步到云端
        NSArray *toBeSyncVideoArray = [self fetchFavoriteDataWithType:TTCloudSyncTypeVideo];
        if (toBeSyncVideoArray) {
            __block NSMutableArray *idsArray = [NSMutableArray array];
            [toBeSyncVideoArray enumerateObjectsUsingBlock:^(TTFavouriteModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [idsArray addObject:@([model.videoID integerValue])];
            }];
            // 短视频
            if (idsArray.count > 0) {
                [self saveVideoFavourite:[idsArray copy]];
            }
        }
        else {
            NSLog(@"数据库没有短视频数据需要云同步");
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 登录 把本地记录和线上记录合并，并同步到云端
        NSArray *toBeSyncMovieArray = [self fetchFavoriteDataWithType:TTCloudSyncTypeMovie];
        if (toBeSyncMovieArray) {
            __block NSMutableArray *idsArray = [NSMutableArray array];
            [toBeSyncMovieArray enumerateObjectsUsingBlock:^(TTFavouriteModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [idsArray addObject:@([model.videoID integerValue])];
            }];
            // 长视频
            if (idsArray.count > 0) {
                [self saveMovieFavourite:[idsArray copy]];
            }
        }
        else {
            NSLog(@"数据库没有长视频数据需要云同步");
        }
    });
}

// 多个短视频收藏 同步的情况
- (BOOL)saveVideoFavourite:(NSArray *)array {
    if ([[TTReachabilityManager sharedInstance] getNetworkStatus] == TTNotReachable) {
        return NO;
    }
    if (!array.count) {
        return NO;
    }
    __block BOOL isSuccess = NO;
    // 短视频本地记录云同步
    @weakify(self);
    [TTDataRequest CloudSyncCollectVideosWithIds:array success:^{
        @strongify(self);
        isSuccess = YES;
        NSLog(@"短视频收藏云同步成功");
        
        // 发通知拉取更新短视频列表
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTKKVideoSyncDidSuccessNotification object:nil];
        });
        
        [self clearVideoDBData];
        
        [self stopVideoTimerPolling];
        
    } failure:^(NSInteger code, NSString *message, NSString *failIds, NSInteger failNum) {
        @strongify(self);
        _videoFailIds = failIds;
        [self clearSyncSuccessAndSaveFailVideoDBData:[self successArray:array failIds:failIds]];
        if (_videoRequestCount <= 5) { // 只轮询5次
            [self startVideoTimerPolling];
        }
        else {
            [self stopVideoTimerPolling];
        }
        NSLog(@"collect %@",message);
        isSuccess = NO;
        NSLog(@"短视频收藏云同步失败");
    }];
    return isSuccess;
}

// 多个长视频收藏 同步的情况
- (BOOL)saveMovieFavourite:(NSArray *)array {
    if ([[TTReachabilityManager sharedInstance] getNetworkStatus] == TTNotReachable) {
        return NO;
    }
    if (!array.count) {
        return NO;
    }
    __block BOOL isSuccess = NO;
    // 长视频本地记录云同步
    @weakify(self);
    [TTDataRequest CloudSyncCollectMoviesWithIds:array success:^{
        @strongify(self);
        isSuccess = YES;
        NSLog(@"长视频收藏云同步成功");
        
        // 发通知拉取更新长视频列表
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTKKMovieSyncDidSuccessNotification object:nil];
        });
        
        [self clearMovieDBData];
        
        [self stopMovieTimerPolling];
        
    } failure:^(NSInteger code, NSString *message, NSString *failIds, NSInteger failNum) {
        @strongify(self);
        isSuccess = NO;
        _movieFailIds = failIds;
        
        [self clearSyncSuccessAndSaveFailMovieDBData:[self successArray:array failIds:failIds]];
        if (_videoRequestCount <= 5) { // 只轮询5次
            [self startMovieTimerPolling];
        }
        else {
            [self stopMovieTimerPolling];
        }
        NSLog(@"collect %@",message);
        NSLog(@"长视频收藏云同步失败");
    }];
    return isSuccess;
}

// 查找同步成功的数组id
- (NSArray *)successArray:(NSArray *)array failIds:(NSString *)failIds {
    NSArray *failIdArray = [failIds componentsSeparatedByString:@","];
    NSMutableArray *successIds = [NSMutableArray arrayWithArray:array];
    for (NSString *videoId in array) {
        if ([failIdArray containsObject:videoId]) {
            // 剔除失败的id
            [successIds removeObject:videoId];
        }
    }
    return [successIds copy];
}

// 获取收藏数据
- (NSArray *)fetchFavoriteDataWithType:(TTCloudSyncType)cloudSyncType {
    // 登录 把本地记录和线上记录合并，并同步到云端
    NSArray *localArray = nil;
    if (cloudSyncType == TTCloudSyncTypeMovie) {
        localArray = [self getLocalAllMovieFavouriteFromDB];
    }
    else {
        localArray = [self getLocalAllVideoFavouriteFromDB];
    }
    return localArray;
}

// 获取短视频数据
- (NSArray *)getLocalAllVideoFavouriteFromDB {
    NSMutableArray *datas = [NSMutableArray array];
    BOOL isSuccess = [_dbManager getAllFavouriteDatasFromTable:[_dbManager getVideoLocalTableName] datas:datas];
    if (isSuccess) {
        return [datas copy];
    }
    return nil;
}

// 获取长视频数据
- (NSArray *)getLocalAllMovieFavouriteFromDB {
    NSMutableArray *datas = [NSMutableArray array];
    BOOL isSuccess = [_dbManager getAllFavouriteDatasFromTable:[_dbManager getMovieLocalTableName] datas:datas];
    if (isSuccess) {
        return [datas copy];
    }
    return nil;
}

#pragma mark - 定时器

- (void)nextVideoSync {
    _videoRequestCount++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *failIdArray = [_videoFailIds componentsSeparatedByString:@","];
        if (failIdArray.count) {
            [self saveVideoFavourite:failIdArray];
        }
    });
}

- (void)nextMovieSync {
    _movieRequestCount++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *failIdArray = [_movieFailIds componentsSeparatedByString:@","];
        if (failIdArray.count) {
            [self saveMovieFavourite:failIdArray];
        }
    });
}

- (void)stopVideoTimerPolling {
    if (_videoTimer) {
        [_videoTimer invalidate];
        _videoTimer = nil;
    }
}

- (void)startVideoTimerPolling {
    if (!_videoTimer) {
        __weak typeof(self)weakSelf = self;
        _videoTimer = [NSTimer tt_timerWithTimeInterval:RetryTimesMargin block:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf nextVideoSync];
        } repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_videoTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1*RetryTimes]];
    }
}

- (void)stopMovieTimerPolling {
    if (_movieTimer) {
        [_movieTimer invalidate];
        _movieTimer = nil;
    }
}

- (void)startMovieTimerPolling {
    if (!_movieTimer) {
        __weak typeof(self)weakSelf = self;
        _movieTimer = [NSTimer tt_timerWithTimeInterval:RetryTimesMargin block:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf nextMovieSync];
        } repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_movieTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1*RetryTimes]];
    }
}

@end
