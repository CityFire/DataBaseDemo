//
//  TTFavouriteManager.m
//  TTKanKan
//
//  Created by wjc on 2017/2/9.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTFavouriteManager.h"
#import "TTPlayerModel.h"
#import "TTMyFavouriteDBManager.h"

typedef NS_ENUM(NSUInteger, TTFavouriteType) {
    TTFavouriteTypeVideo = 0,  // 视频
    TTFavouriteTypeMovie = 1,  // 影片
};

@implementation TTFavouriteManager {
    TTMyFavouriteDBManager *_dbManager;
}

#pragma mark - 单例

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Initialized

- (instancetype)init {
    self = [super init];
    if (self) {
        _dbManager = [TTMyFavouriteDBManager sharedInstance];
    }
    return self;
}

#pragma mark - public methods
#pragma mark - 短视频收藏相关
// 获取单个短视频的收藏状态
- (BOOL)getVideoFavouriteStatusWithPlayerModel:(TTPlayerModel *)playerModel {
    BOOL isFavourite = [_dbManager getFavoriteStatusFromTable:[_dbManager getVideoLocalTableName] playerModel:playerModel];
    
    return isFavourite;
}

// 单个短视频收藏
- (BOOL)saveVideoFavouriteWithPlayerModel:(TTPlayerModel *)playerModel {
    return [self saveFavouriteWithPlayerModel:playerModel favouriteType:TTFavouriteTypeVideo];
}

// 取消单个短视频收藏
- (BOOL)cancelVideoFavouriteWithPlayerModel:(TTPlayerModel *)playerModel {
    return [self cancelFavouriteWithPlayerModel:playerModel favouriteType:TTFavouriteTypeVideo];
}

// 获取短视频收藏列表
- (NSArray *)getVideoFavoriteData {
    
    return [self fetchFavoriteDataWithType:TTFavouriteTypeVideo];
}

// 分页获取短视频收藏
- (NSArray *)getVideoFavoriteDataByPage:(NSUInteger)page pageSize:(NSUInteger)pageSize {
    
    return [self fetchFavoriteDataWithType:TTFavouriteTypeVideo page:page pageSize:pageSize];
}

// 获取短视频收藏总页数
- (NSUInteger)getVideoFavoriteTotalPageCountByPageSize:(NSUInteger)pageSize {
    
    return [_dbManager getFavoriteTotalPageCountFromTable:[_dbManager getVideoLocalTableName] pageSize:pageSize];
}

#pragma mark - 长视频收藏相关
// 获取单个长视频的收藏状态
- (BOOL)getMovieFavouriteStatusWithPlayerModel:(TTPlayerModel *)playerModel {
    BOOL isFavourite = [_dbManager getFavoriteStatusFromTable:[_dbManager getMovieLocalTableName] playerModel:playerModel];
    
    return isFavourite;
}

// 单个长视频收藏
- (BOOL)saveMovieFavouriteWithPlayerModel:(TTPlayerModel *)playerModel {
    
    return [self saveFavouriteWithPlayerModel:playerModel favouriteType:TTFavouriteTypeMovie];
}

// 取消单个长视频收藏
- (BOOL)cancelMovieFavouriteWithPlayerModel:(TTPlayerModel *)playerModel {
    
    return [self cancelFavouriteWithPlayerModel:playerModel favouriteType:TTFavouriteTypeMovie];
}

// 获取长视频收藏列表
- (NSArray *)getMovieFavoriteData {
    
    return [self fetchFavoriteDataWithType:TTFavouriteTypeMovie];
}

// 分页获取长视频收藏
- (NSArray *)getMovieFavoriteDataByPage:(NSUInteger)page pageSize:(NSUInteger)pageSize {
    
    return [self fetchFavoriteDataWithType:TTFavouriteTypeMovie page:page pageSize:pageSize];
}

// 获取长视频收藏总页数
- (NSUInteger)getMovieFavoriteTotalPageCountByPageSize:(NSUInteger)pageSize {
    
    return [_dbManager getFavoriteTotalPageCountFromTable:[_dbManager getMovieLocalTableName] pageSize:pageSize];
}

// 分页获取本地数据库收藏数据
- (NSArray *)fetchFavoriteDataWithType:(TTFavouriteType)favouriteType page:(NSUInteger)page pageSize:(NSUInteger)pageSize {
    NSArray *localArray = nil;
    if (favouriteType == TTFavouriteTypeMovie) {
        localArray = [self getLocalMovieFavouriteFromDBByPage:page pageSize:pageSize];
    }
    else {
        localArray = [self getLocalVideoFavouriteFromDBByPage:page pageSize:pageSize];
    }
    return localArray;
}

// 获取本地数据库收藏数据
- (NSArray *)fetchFavoriteDataWithType:(TTFavouriteType)favouriteType {
    NSArray *localArray = nil;
    if (favouriteType == TTFavouriteTypeMovie) {
        localArray = [self getLocalAllMovieFavouriteFromDB];
    }
    else {
        localArray = [self getLocalAllVideoFavouriteFromDB];
    }
    return localArray;
}

#pragma mark - private methods

#pragma mark - 收藏或取消收藏
- (BOOL)favouriteWithPlayerModel:(TTPlayerModel *)playerModel save:(BOOL)isSave favouriteType:(TTFavouriteType)favouriteType {
    if (!playerModel.movieId) {
        return NO;
    }
    NSString *tableName = nil;
    NSString *movieID = [NSString stringWithFormat:@"%ld", (long)playerModel.movieId];
    BOOL isSuccess = NO;
    if (favouriteType == TTFavouriteTypeMovie) {
        tableName = [_dbManager getMovieLocalTableName];
    }
    else {
        tableName = [_dbManager getVideoLocalTableName];
    }
    if (isSave) {
        // 收藏
        BOOL isExist = [_dbManager getIsExistFromTable:tableName MovieID:movieID];
        if (isExist) {
            isSuccess = [_dbManager updateSingleFavouriteStatusFromTable:tableName MovieID:movieID bStatused:YES];
            if (isSuccess) {
                NSLog(@"收藏成功");
            }
            else {
                NSLog(@"收藏失败");
            }
        }
        else {
            isSuccess = [_dbManager insertPlayerModelToTable:tableName playerModel:playerModel];
            if (isSuccess) {
                NSLog(@"收藏成功");
            }
            else {
                NSLog(@"收藏失败");
            }
        }
    }
    else {
        // 取消收藏
        BOOL isExist = [_dbManager getIsExistFromTable:tableName MovieID:movieID];
        if (isExist) {
            isSuccess =  [_dbManager deleteFavouriteDataFromTable:tableName MovieID:movieID];
            if (isSuccess) {
                NSLog(@"收藏取消成功");
            }
            else {
                NSLog(@"收藏取消失败");
            }
        }
    }
    return isSuccess;
}

- (BOOL)saveFavouriteWithPlayerModel:(TTPlayerModel *)playerModel favouriteType:(TTFavouriteType)favouriteType {
    return [self favouriteWithPlayerModel:playerModel save:YES favouriteType:favouriteType];
}

- (BOOL)cancelFavouriteWithPlayerModel:(TTPlayerModel *)playerModel favouriteType:(TTFavouriteType)favouriteType {
    return [self favouriteWithPlayerModel:playerModel save:NO favouriteType:favouriteType];
}

#pragma mark - getter methods
#pragma mark - 分页获取

- (NSArray *)getLocalVideoFavouriteFromDBByPage:(NSUInteger)page pageSize:(NSUInteger)pageSize {
    NSMutableArray *datas = [NSMutableArray array];
    BOOL isSuccess = [_dbManager getFavouriteDatasFromTable:[_dbManager getVideoLocalTableName] page:page pageSize:pageSize datas:datas];
    if (isSuccess) {
        return [datas copy];
    }
    return nil;
}

- (NSArray *)getLocalMovieFavouriteFromDBByPage:(NSUInteger)page pageSize:(NSUInteger)pageSize {
    NSMutableArray *datas = [NSMutableArray array];
    BOOL isSuccess = [_dbManager getFavouriteDatasFromTable:[_dbManager getMovieLocalTableName] page:page pageSize:pageSize datas:datas];
    if (isSuccess) {
        return [datas copy];
    }
    return nil;
}

#pragma mark - 全部获取

- (NSArray *)getLocalAllVideoFavouriteFromDB {
    NSMutableArray *datas = [NSMutableArray array];
    BOOL isSuccess = [_dbManager getAllFavouriteDatasFromTable:[_dbManager getVideoLocalTableName] datas:datas];
    if (isSuccess) {
        return [datas copy];
    }
    return nil;
}

- (NSArray *)getLocalAllMovieFavouriteFromDB {
    NSMutableArray *datas = [NSMutableArray array];
    BOOL isSuccess = [_dbManager getAllFavouriteDatasFromTable:[_dbManager getMovieLocalTableName] datas:datas];
    
    if (isSuccess) {
        return [datas copy];
    }
    return nil;
}

@end
