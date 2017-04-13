//
//  TTDBManager.m
//  TTKanKan
//
//  Created by wjc on 2017/1/22.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTDBManager.h"

@implementation TTDBManager

- (BOOL)isTableExist:(NSString *)tableName {
    __block BOOL bExist = NO;
    if (!tableName || [tableName isEqualToString:@""]) {
        return bExist;
    }
    // 获得所有表的索引 判断表是否存在
    NSString *querySql = [NSString stringWithFormat:@"select name from sqlite_master where type='table' AND name='%@'", tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            NSLog(@"Could not open db");
            return;
        }
        FMResultSet *rs = [db executeQuery:querySql];
        if ([rs next]) {
            bExist = YES;
        }
        [db close];
    }];
    return bExist;
}

// 创建表
- (BOOL)createDBTable:(NSString *)tableName {
    return NO;
}

- (time_t)getCurrentTime {
    time_t loctime;
    loctime = time(NULL);
    return loctime;
}

@end
