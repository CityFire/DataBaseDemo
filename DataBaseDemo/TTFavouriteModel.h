//
//  TTFavouriteModel.h
//  TTKanKan
//
//  Created by wjc on 2017/1/3.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTDataListModel.h"

// 云同步状态
typedef NS_ENUM(NSUInteger, TTCloudSyncStatus) {
    TTCloudSyncStatusSynced = 1, // 已同步
    TTCloudSyncStatusUnSync = 2, // 未同步
};

@interface TTFavouriteModel : NSObject

/** 视频标题 */
@property (nonatomic, copy) NSString *title;
/** 视频ID */
@property (nonatomic, copy) NSString *videoID;
/** 视频封面 */
@property (nonatomic, copy) NSString *posterUrl;
/** 视频时长 */
@property (nonatomic, copy) NSString *timeLength;

@property (nonatomic, assign) TTCloudSyncStatus syncStatus;

@end

@interface TTMovieFavouriteModel : TTDataListModel

@end

@interface TTVideoFavouriteModel : TTDataListModel

@end


