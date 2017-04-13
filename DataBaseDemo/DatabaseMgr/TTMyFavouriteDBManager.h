//
//  TTMyFavouriteDBManager.h
//  TTKanKan
//
//  Created by wjc on 2017/1/20.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTDBManager.h"
@class TTPlayerModel;
@class TTFavouriteModel;

@interface TTMyFavouriteDBManager : TTDBManager

+ (instancetype)sharedInstance;

#pragma mark - 建表

#pragma mark - 读取表名
// Video本地数据表名
- (NSString *)getVideoLocalTableName;
// Movie本地数据表名
- (NSString *)getMovieLocalTableName;

#pragma mark - 插入数据
// 单个
- (BOOL)insertPlayerModelToTable:(NSString *)tableName playerModel:(TTPlayerModel *)playerModel;
// 多个
- (BOOL)insertPlayerModelToTable:(NSString *)tableName datas:(NSArray<TTPlayerModel *> *)datas;

#pragma mark - 更新数据
// 更新ID为movieID的记录的收藏状态
- (BOOL)updateSingleFavouriteStatusFromTable:(NSString *)tableName MovieID:(NSString *)movieID bStatused:(BOOL)bStatused;

#pragma mark - 删除数据
// 删除单个收藏的数据
- (BOOL)deleteFavouriteDataFromTable:(NSString *)tableName MovieID:(NSString *)movieID;
// 删除不包含movieID的收藏数据
- (BOOL)deleteFavouriteDataFromTable:(NSString *)tableName ExcludeMovieID:(NSString *)movieID;
// 删除多个收藏的模型数据
- (BOOL)deleteFavouriteDataFromTable:(NSString *)tableName datas:(NSArray<TTPlayerModel *> *)datas;
// 删除多个id数组收藏的NSNumber数据
- (BOOL)deleteFavouriteNumberDataFromTable:(NSString *)tableName datas:(NSArray<NSNumber *> *)datas;
// 删除所有收藏的数据
- (BOOL)deleteAllFavouriteDataFromTable:(NSString *)tableName;

#pragma mark - 查询数据
// 查询某个数据是否存在，存在的话就可以直接更新相关的收藏状态，否则需要插入新数据到表中
- (BOOL)getIsExistFromTable:(NSString *)tableName MovieID:(NSString *)movieID;
// 获取某个数据收藏状态 返回YES为已收藏，NO为未收藏
- (BOOL)getFavoriteStatusFromTable:(NSString *)tableName playerModel:(TTPlayerModel *)playerModel;
// 获取收藏总页数
- (NSUInteger)getFavoriteTotalPageCountFromTable:(NSString *)tableName pageSize:(NSUInteger)pageSize;
// 分页查询 获取page页的pageSize个收藏数据 SQL语句查询性能优化
- (BOOL)getFavouriteDatasFromTable:(NSString *)tableName page:(NSInteger)page pageSize:(NSInteger)pageSize datas:(NSMutableArray<TTFavouriteModel *> *)datas;
// 获取所有的收藏数据
- (BOOL)getAllFavouriteDatasFromTable:(NSString *)tableName datas:(NSMutableArray<TTFavouriteModel *> *)datas;

#pragma mark - 合并 去重

@end
