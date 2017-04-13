//
//  TTFavouriteManager.h
//  TTKanKan
//
//  Created by wjc on 2017/2/9.
//  Copyright © 2017年 kankan. All rights reserved.
//  专门管理收藏的本地存储记录

#import <Foundation/Foundation.h>
@class TTPlayerModel;

@interface TTFavouriteManager : NSObject
/** 单例 */
+ (instancetype)sharedInstance;

#pragma makr - 短视频收藏相关
/** 获取单个短视频的收藏状态 */
- (BOOL)getVideoFavouriteStatusWithPlayerModel:(TTPlayerModel *)playerModel;
/** 单个短视频收藏 */
- (BOOL)saveVideoFavouriteWithPlayerModel:(TTPlayerModel *)playerModel;
/** 取消单个短视频收藏 */
- (BOOL)cancelVideoFavouriteWithPlayerModel:(TTPlayerModel *)playerModel;
/** 获取短视频收藏 */
- (NSArray *)getVideoFavoriteData;
/** 分页获取短视频收藏 */
- (NSArray *)getVideoFavoriteDataByPage:(NSUInteger)page pageSize:(NSUInteger)pageSize;
/** 获取短视频收藏总页数 */
- (NSUInteger)getVideoFavoriteTotalPageCountByPageSize:(NSUInteger)pageSize;

#pragma makr - 长视频收藏相关
/** 获取单个长视频的收藏状态 */
- (BOOL)getMovieFavouriteStatusWithPlayerModel:(TTPlayerModel *)playerModel;
/** 单个长视频收藏 */
- (BOOL)saveMovieFavouriteWithPlayerModel:(TTPlayerModel *)playerModel;
/** 取消单个长视频收藏 */
- (BOOL)cancelMovieFavouriteWithPlayerModel:(TTPlayerModel *)playerModel;
/** 获取长视频收藏 */
- (NSArray *)getMovieFavoriteData;
/** 分页获取长视频收藏 */
- (NSArray *)getMovieFavoriteDataByPage:(NSUInteger)page pageSize:(NSUInteger)pageSize;
/** 获取长视频收藏总页数 */
- (NSUInteger)getMovieFavoriteTotalPageCountByPageSize:(NSUInteger)pageSize;

@end
