//
//  TTDBManager.h
//  TTKanKan
//
//  Created by wjc on 2017/1/22.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface TTDBManager : NSObject {
    FMDatabaseQueue *_dbQueue;
}

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

// 查询表是否存在
- (BOOL)isTableExist:(NSString *)tableName;
// 创建表 子类重写
- (BOOL)createDBTable:(NSString *)tableName;

- (time_t)getCurrentTime;

@end
