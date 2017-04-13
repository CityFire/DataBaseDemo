//
//  TTDetailDefine.h
//  iKanKan
//
//  Created by kankan on 15/12/14.
//  Copyright © 2015年 Nesound Kankan Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef TTDetailDefine_h
#define TTDetailDefine_h


// 创建详情页的来源
typedef NS_ENUM(NSInteger,TTDetailViewFrom){
    TTDetailFromRcmmd       = 0,                // 推荐页
    TTDetailFromTopic       = 1,                // 专题
    TTDetailFromVip         = 2,                // vip
    TTDetailFromChannel     = 3,                // 视频页
    TTDetailFromSearch      = 4,                // 搜索页
    TTDetailFromFavorite    = 5,                // 收藏
    TTDetailFromPlayHistory = 6,                // 播放记录
    TTDetailFromCache       = 7,                // 下载缓存
    TTDetailFromLocal       = 8,                // 本地
    TTDetailFromRelate      = 9,                // 相关
    TTDetailFromPush        = 10,               // 极光推送
    TTDetailFromHotTab      = 11,               // 热点

    
};
// 创建详情页的类型
typedef NS_ENUM(NSInteger,TTDetailViewType){
    TTDetailViewTypeDefault     = 0,                // 普通详情页
    TTDetailViewTypeVideo       = 1,                // 看看短视频详情页
    TTDetailViewTypeMember      = 2,                // 会员详情页
    TTDetailViewTypeLocal       = 3,                // 本地播放详情页
    TTDetailViewTypeHot         = 4,                // 热点详情页
};
// 视频类型,依据谭达返回，增加几个类型.短视频搜索接口类型多余详情页接口的类型（详情页接口短视频三种类型101 102 100）搜索则（101 102 103 104 105 106）
typedef NS_ENUM(NSInteger,TTVideoType){
    TTVideoTypeMovie            = 1,             // 电影
    TTVideoTypeTeleplay         = 2,             // 电视剧
    TTVideoTypeTV               = 3,             // 综艺
    TTVideoTypeAnime            = 4,             // 动漫
    TTVideoTypeDocumentary      = 5,             // 纪录片
    TTVideoTypeLesson           = 6,             // 公开课
    TTVideoTypeVMovie           = 7,             // 微电影
    TTVideoTypeFashion          = 8,             // 时尚
    TTVideoTypeVideoDefault     = 100,           // 短视频默认类型
    TTVideoTypeEntertainment    = 101,           // 娱乐
    TTVideoTypeVideo            = 102,           // 视频快报
    TTVideoTypeMtv              = 103,           // MTV
    TTVideoTypeSports           = 104,           // 体育
    TTVideoTypeJoke             = 105,           // 搞笑
    TTVideoTypeShortAnime       = 106,           // 短视频动漫
    TTVideoTypeVipMvoie         = 200,           // VIP电影
    TTVideoTypeMovieClip        = 300,           // 片花
};
// 视频清晰度
typedef NS_ENUM(NSInteger,TTVideoProfile){
    TTVideoProfile240    = 0,             //
    TTVideoProfile320    = 1,             // 流畅  320p
    TTVideoProfile480    = 2,             // 标清  480p
    TTVideoProfile720    = 3,             // 高清  720p
    TTVideoProfile1080   = 4,             // 超清  1080p
    TTVideoProfileUnKnow = -1,
};

// 子集列表Cell样式
typedef NS_ENUM(NSUInteger, TTDetailEpisodeCellType) {
    TTDetailEpisodeCellGridNormal,              // 格子
    TTDetailEpisodeCellGridAdvance,             // 格子 预告
    TTDetailEpisodeCellGridVip,                 // 格子 vip
    TTDetailEpisodeCellRectNormal,              // 矩形 （电影、预告、vip页的剧集、综艺）
    TTDetailEpisodeCellVideoNormal,             // 短视频 热点视频
};


#define TTDetailKillSelf @"TTDetailKillSelf"

#define TTPushBackSmall @"TTPushBackSmall"

#endif /* TTDetailDefine_h */
