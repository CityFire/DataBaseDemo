//
//  TTMyFavouriteDBManager.m
//  TTKanKan
//
//  Created by wjc on 2017/1/20.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTMyFavouriteDBManager.h"
#import "FMDatabaseAdditions.h"
#import "TTPlayerModel.h"
#import "TTFavouriteModel.h"
#import "NSString+Util.h"

#define FavouriteDBName @"com.kankan.TTKanKan.Favourite.db"
// 数据库路径
#define DocumentsPath   [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface TTMyFavouriteDBManager ()

@end

@implementation TTMyFavouriteDBManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@", DocumentsPath, FavouriteDBName];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

#pragma mark - 建表
- (BOOL)createDBTable:(NSString *)tableName {
    if ([tableName length] == 0) {
        return NO;
    }
    __block BOOL bRet = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 生成表
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *executeStr = [NSString stringWithFormat:@"create table %@ (LocID integer primary key autoincrement not null,MovieID text unique,MovieTitle text,PosterUrl text,TimeLength integer,CreateTime integer,FavouriteStatus integer)", tableName];
        bRet = [db executeUpdate:executeStr];
        [db close];
    }];
    return bRet;
}

// Video本地数据表
- (NSString *)getVideoLocalTableName {
    return @"Local_Video_Favourite_table";
}

// Movie本地数据表
- (NSString *)getMovieLocalTableName {
    return @"Local_Movie_Favourite_table";
}

#pragma mark - 插入数据
// 插入数据到表
// 单个
- (BOOL)insertPlayerModelToTable:(NSString *)tableName playerModel:(TTPlayerModel *)playerModel {
    __block BOOL bRet = YES;
    if (![self isTableExist:tableName]) {
        bRet = [self createDBTable:tableName];
    }
    if (!bRet) {
        NSLog(@"创建表失败");
        return bRet;
    }
    if (!playerModel.movieId) {
        NSLog(@"MovieID不能为空");
        return NO;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where MovieID = %@", tableName,@(playerModel.movieId)];
        FMResultSet *rs = [db executeQuery:querySql];
        if ([rs next]) {
            NSLog(@"已存在");
            [db close];
            return;
        }
        NSUInteger locID = [self getLocIDFromTable:tableName db:db]+1;
        NSString *movieID = [NSString stringWithFormat:@"%@", @(playerModel.movieId)];
        NSString *movieTitle = playerModel.title;
        NSString *posterUrl = playerModel.vPosterPath;
        NSString *timeLength = [NSString stringWithFormat:@"%@", @(playerModel.movieLength)];
        time_t createTime = [self getCurrentTime];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (LocID,MovieID,MovieTitle,PosterUrl,TimeLength,CreateTime,FavouriteStatus) values (%@,'%@','%@','%@','%@',%@,%@)",tableName,@(locID),movieID,movieTitle,posterUrl,timeLength,@(createTime),@(1)];
        bRet = [db executeUpdate:insertSql];
        [db close];
        if (!bRet) {
            return;
        }
    }];
    return bRet;
}

// 多个
- (BOOL)insertPlayerModelToTable:(NSString *)tableName datas:(NSArray<TTPlayerModel *> *)datas {
    __block BOOL bRet = YES;
    if (![self isTableExist:tableName]) {
        bRet = [self createDBTable:tableName];
    }
    if (!bRet) {
        NSLog(@"创建表失败");
        return bRet;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        [db beginTransaction];
        @try {
            for (TTPlayerModel *model in datas) {
                NSString *querySql = [NSString stringWithFormat:@"select * from %@ where MovieID = %@", tableName,@(model.movieId)];
                FMResultSet *rs = [db executeQuery:querySql];
                if ([rs next]) {
                    NSLog(@"已存在");
                    [db close];
                    return;
                }
                NSUInteger locID = [self getLocIDFromTable:tableName db:db]+1;
                NSString *movieID = [NSString stringWithFormat:@"%@", @(model.movieId)];
                NSString *movieTitle = model.title;
                NSString *posterUrl = model.vPosterPath;
                NSString *timeLength = [NSString stringWithFormat:@"%@", @(model.movieLength)];
                time_t createTime = [self getCurrentTime];
                
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (LocID,MovieID,MovieTitle,PosterUrl,TimeLength,CreateTime,FavouriteStatus) values (%@,'%@','%@','%@','%@',%@,%@)",tableName,@(locID),movieID,movieTitle,posterUrl,timeLength,@(createTime),@(1)];
                bRet = [db executeUpdate:insertSql];
            }
        } @catch (NSException *exception) {
            [db rollback];
        } @finally {
            [db commit];
        }
        [db close];
        if (!bRet) {
            return;
        }
    }];
    return bRet;
}

#pragma mark - 更新数据
// 更新ID为movieID的记录的收藏状态
- (BOOL)updateSingleFavouriteStatusFromTable:(NSString *)tableName MovieID:(NSString *)movieID bStatused:(BOOL)bStatused {
    __block BOOL bRet = NO;
    if (![self isTableExist:tableName]) {
        NSLog(@"表名为空或不存在");
        return NO;
    }
    if (!movieID || [movieID isEqualToString:@""]) {
        NSLog(@"MovieID为空");
        return NO;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *udpdateSql = [NSString stringWithFormat:@"update %@ set FavouriteStatus = %@ where MovieID = %@", tableName, @(bStatused), movieID];
        bRet = [db executeUpdate:udpdateSql];
        [db close];
    }];
    return bRet;
}

#pragma mark - 删除数据
// 删除单个收藏的数据
- (BOOL)deleteFavouriteDataFromTable:(NSString *)tableName MovieID:(NSString *)movieID {
    if (![self isTableExist:tableName]) {
        NSLog(@"表名为空");
        return NO;
    }
    if (!movieID || [movieID isEqualToString:@""]) {
        NSLog(@"MovieID为空");
        return NO;
    }
    __block BOOL bRet = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where MovieID = %@", tableName, movieID];
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        bRet = [db executeUpdate:deleteSql];
        [db close];
    }];
    return bRet;
}

// 删除多个收藏的模型数据
- (BOOL)deleteFavouriteDataFromTable:(NSString *)tableName datas:(NSArray<TTPlayerModel *> *)datas {
    __block BOOL bRet = YES;
    if (![self isTableExist:tableName]) {
        NSLog(@"表不存在或为空");
        return NO;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        [db beginTransaction];
        
        @try {
            for (TTPlayerModel *model in datas) {
                NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where MovieID = %@", tableName, @(model.movieId)];
                bRet = [db executeUpdate:deleteSql];
            }
        } @catch (NSException *exception) {
            [db rollback];
        } @finally {
            [db commit];
        }
        
        [db close];
    }];
    return bRet;
    
}

// 删除多个id数组收藏的NSNumber数据
- (BOOL)deleteFavouriteNumberDataFromTable:(NSString *)tableName datas:(NSArray<NSNumber *> *)datas {
    __block BOOL bRet = YES;
    if (![self isTableExist:tableName]) {
        NSLog(@"表不存在或为空");
        return NO;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        [db beginTransaction];
        
        @try {
            for (NSNumber *number in datas) {
                NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where MovieID = %@", tableName, number];
                bRet = [db executeUpdate:deleteSql];
            }
        } @catch (NSException *exception) {
            [db rollback];
        } @finally {
            [db commit];
        }
        
        [db close];
    }];
    return bRet;
    
}

// 删除不包含movieID的收藏数据
- (BOOL)deleteFavouriteDataFromTable:(NSString *)tableName ExcludeMovieID:(NSString *)movieID {
    __block BOOL bRet = YES;
    if (![self isTableExist:tableName]) {
        NSLog(@"表不存在或为空");
        return NO;
    }
    if (!movieID || [movieID isEqualToString:@""]) {
        NSLog(@"MovieID为空");
        return NO;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where not exists (select MovieID from %@ where MovieID = %@)", tableName, tableName, movieID];
        bRet = [db executeUpdate:deleteSql];
        [db close];
    }];
    return bRet;
}

// 删除所有收藏的数据
- (BOOL)deleteAllFavouriteDataFromTable:(NSString *)tableName {
    if (![self isTableExist:tableName]) {
        NSLog(@"表不存在");
        return NO;
    }
    __block BOOL bRet = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where FavouriteStatus = %@", tableName, @(1)];
        bRet = [db executeUpdate:deleteSql];
        [db close];
    }];
    return bRet;
}

#pragma mark - 查询数据

// 查询某个数据是否存在，存在的话就可以直接更新相关的收藏状态，否则需要插入新数据到表中
- (BOOL)getIsExistFromTable:(NSString *)tableName MovieID:(NSString *)movieID {
    if (![self isTableExist:tableName]) {
        NSLog(@"表不存在或为空");
        return NO;
    }
    if (!movieID || [movieID isEqualToString:@""]) {
        NSLog(@"MovieID为空");
        return NO;
    }
    __block BOOL bRet = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where MovieID = %@ limit 1", tableName, movieID];
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        FMResultSet *rs = [db executeQuery:querySql];
        if ([rs next]) {
            bRet = YES;
        }
        [db close];
    }];
    return bRet;
}

// 获取记录ID
- (NSUInteger)getLocIDFromTable:(NSString *)tableName db:(FMDatabase *)db {
    __block NSUInteger locID = 0;
    NSString *querySql = [NSString stringWithFormat:@"select LocID from %@ order by LocID desc",tableName];
    FMResultSet *rs = [db executeQuery:querySql];
    if ([rs next]) {
        locID = [rs intForColumn:@"LocID"];
    }
    return locID;
}

// 获取某个数据收藏状态
- (BOOL)getFavoriteStatusFromTable:(NSString *)tableName playerModel:(TTPlayerModel *)playerModel {
    if (tableName == nil || ![self isTableExist:tableName]) {
        NSLog(@"表不存在 or 表名为空");
        return NO;
    }
    if (!playerModel.movieId) {
        NSLog(@"MovieID为空");
        return NO;
    }
    __block BOOL isFavourite = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *querySql = [NSString stringWithFormat:@"select FavouriteStatus from %@ where MovieID = %@", tableName, @(playerModel.movieId)];
        FMResultSet *rs = [db executeQuery:querySql];
        if ([rs next]) {
            isFavourite = [rs boolForColumn:@"FavouriteStatus"];
        }
        [db close];
    }];
    return isFavourite;
}

// 获取收藏总页数
- (NSUInteger)getFavoriteTotalPageCountFromTable:(NSString *)tableName pageSize:(NSUInteger)pageSize {
    if (tableName == nil || ![self isTableExist:tableName]) {
        NSLog(@"表不存在 or 表名为空");
        return NO;
    }
    __block NSUInteger totalPageCount = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *querySql = [NSString stringWithFormat:@"select count(*) from %@", tableName];
        int totalCount = [db intForQuery:querySql];
        if (pageSize != 0) {
            totalPageCount = (totalCount  +  pageSize  - 1) / pageSize;
        }
        
        [db close];
    }];
    return totalPageCount;
}

// 获取page页的pageSize个收藏数据 SQL语句查询性能优化 分页 复合索引 游标
- (BOOL)getFavouriteDatasFromTable:(NSString *)tableName page:(NSInteger)page pageSize:(NSInteger)pageSize datas:(NSMutableArray<TTFavouriteModel *> *)datas {
    if (tableName == nil || ![self isTableExist:tableName]) {
        NSLog(@"表不存在 or 表名为空");
        return NO;
    }
    if (page < 1) {
        NSLog(@"page不能小于1");
        return NO;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
//        NSString *querySql = [NSString stringWithFormat:@"select * from %@ LocID >= (select LocID from %@ where FavouriteStatus = %@ order by CreateTime desc limit %@, %@) where FavouriteStatus = %@ order by CreateTime desc limit %@", tableName, tableName, @(1), @(pageSize*(page-1)), @(1), @(1), @(pageSize)];
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where FavouriteStatus = %@ order by CreateTime desc limit %@ offset %@", tableName, @(1), @(pageSize), @((page-1) * pageSize)];
        FMResultSet *rs = [db executeQuery:querySql];
        while ([rs next]) {
            TTFavouriteModel *data = [[TTFavouriteModel alloc] init];
            NSString *movieTitle    = [rs stringForColumn:@"MovieTitle"];
            NSString *PosterUrl = [rs stringForColumn:@"PosterUrl"];
            NSInteger timeLength   = [rs intForColumn:@"TimeLength"];
            NSString *movieID = [rs stringForColumn:@"MovieID"];
            data.title = (movieTitle?movieTitle:@"");
            data.posterUrl = (PosterUrl?PosterUrl:@"");
            data.timeLength = [NSString timeStringWithTimeLength:timeLength];
            data.videoID = movieID;
            
            [datas addObject:data];
        }
        [db close];
    }];
    return YES;
}

// 获取所有的收藏数据
- (BOOL)getAllFavouriteDatasFromTable:(NSString *)tableName datas:(NSMutableArray<TTFavouriteModel *> *)datas {
    if (tableName == nil || ![self isTableExist:tableName]) {
        NSLog(@"表不存在 or 表名为空");
        return NO;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where FavouriteStatus = %@ order by CreateTime desc", tableName, @(1)];//  limit 100
        FMResultSet *rs = [db executeQuery:querySql];
        while ([rs next]) {
            TTFavouriteModel *data = [[TTFavouriteModel alloc] init];
//            NSUInteger locID        = [rs intForColumn:@"LocID"];
            NSString *movieTitle    = [rs stringForColumn:@"MovieTitle"];
            NSString *PosterUrl = [rs stringForColumn:@"PosterUrl"];
            NSInteger timeLength   = [rs intForColumn:@"TimeLength"];
//            NSInteger favourStatus = [rs intForColumn:@"FavouriteStatus"];
            NSString *movieID = [rs stringForColumn:@"MovieID"];
//            data.LocID = [NSString stringWithFormat:@"%@", @(locID)];
            data.title = (movieTitle?movieTitle:@"");
            data.posterUrl = (PosterUrl?PosterUrl:@"");
            data.timeLength = [NSString timeStringWithTimeLength:timeLength];
            data.videoID = movieID;
            
            [datas addObject:data];
        }
        [db close];
    }];
    
    return YES;
}


#pragma mark - 合并 去重
// 合并数据
- (BOOL)mergeAllFavouriteDataFromTable:(NSString *)fromTableName toTable:(NSString *)toTableName {
    if (!fromTableName || !toTableName || ![self isTableExist:fromTableName] || ![self isTableExist:toTableName]) {
        NSLog(@"表不存在 or 表名为空");
        return NO;
    }
    __block BOOL bRet = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ select * from %@", toTableName, fromTableName];
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        bRet = [db executeUpdate:insertSql];
        [db close];
    }];
    return bRet;
}

// 去掉重复的数据 MovieID不是unique的情况
- (BOOL)deleteRepeatDataFromTable:(NSString *)tableName {
    if (!tableName || ![self isTableExist:tableName]) {
        NSLog(@"表不存在 or 表名为空");
        return NO;
    }
    __block BOOL bRet = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where LocID not in (select max(LocID) from %@ group by MovieID)", tableName, tableName];
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        bRet = [db executeUpdate:deleteSql];
        [db close];
    }];
    return bRet;
}

@end
