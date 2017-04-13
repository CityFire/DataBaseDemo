//
//  TTFavouriteModel.m
//  TTKanKan
//
//  Created by wjc on 2017/1/3.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTFavouriteModel.h"

@implementation TTFavouriteModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"videoID"  : @"id",
             @"posterUrl"  : @"poster",
             @"timeLength"  : @"time_length"};
}

@end

@implementation TTMovieFavouriteModel

+ (NSDictionary *)modelCustomPropertyMapper {
    NSMutableDictionary *dict = [[super modelCustomPropertyMapper] mutableCopy];
    [dict setObject:@"movie" forKey:@"dataList"];
    return [dict copy];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"dataList" : TTFavouriteModel.class,
             };
}

@end


@implementation TTVideoFavouriteModel

+ (NSDictionary *)modelCustomPropertyMapper {
    NSMutableDictionary *dict = [[super modelCustomPropertyMapper] mutableCopy];
    [dict setObject:@"videos" forKey:@"dataList"];
    return [dict copy];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"dataList" : TTFavouriteModel.class,
             };
}

@end

