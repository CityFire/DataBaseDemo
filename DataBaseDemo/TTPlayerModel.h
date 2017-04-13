//
//  TTPlayerModel.h
//  DataBaseDemo
//
//  Created by wjc on 2017/4/13.
//  Copyright © 2017年 CityFire. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 海报总结：
 
 1.vip视频只有横海报，所有的子集共用详情里面的一张海报（子集没有提供相应的海报）
 播放历史显示海报 每个子集海报都一样都是横屏海报
 
 2.短视频只有横海报，每个子集（其实是相关视频）都有独立的海报
 播放历史显示海报 显示当前子集的截图
 
 3.看看视频 有横屏、竖屏海报（有可能为空），每个子集也有截图
 播放历史显示海报，优先显示截图，如果没有截图显示横屏海报
 
 下载
 电影：直接显示竖屏海报
 电视剧：外面显示竖屏海报，里层显示子集截图
 */

#import "TTDetailDefine.h"

/*********  清晰度Model  ************/


@interface TTPlayerProfileModel : NSObject

@property (nonatomic)       TTVideoProfile  profile;
@property (nonatomic,copy)  NSString *      profileName;

- (instancetype)initWithProfie:(TTVideoProfile)profile;

@end


/************** url model **********/
@interface TTPlayerEpisodeUrlModel : NSObject
// 清晰度
@property (nonatomic)       NSInteger   profile;
// 文件大小 kb
@property (nonatomic)       NSUInteger  fileSize;
// 播放链接
@property (nonatomic,copy)  NSString *  url;
// 播放长度 s
@property (nonatomic)  NSUInteger  playLength;
// cdn类型
@property (nonatomic)  NSUInteger  cdnType;

@end

/********************  Episode ********************/

@interface TTPlayerEpisodeModel : NSObject
// movieid 合集id
@property (nonatomic)           NSUInteger  movieId;
// episodeid 子集id
@property (nonatomic)           NSUInteger  episodeId;
// 标题 合集标题
@property (nonatomic,copy)      NSString *  movieTitle;
// 标题 子集标题
@property (nonatomic,copy)      NSString *  episodeTitle;
// 视频总长
@property (nonatomic)           NSUInteger  playlength;
// 截图路径
@property (nonatomic,copy)      NSString *  screen_shot;
// 子集index
@property (nonatomic,assign)    NSInteger   index;
//0 代表已看 1代表正在看 2代表未看
@property (nonatomic,assign)    NSInteger   alreadyRead;
//子集的urls 每个清晰度一个ur  TTPlayerEpisodeUrlModel[]
@property (nonatomic,strong,getter=getUrls)  NSMutableArray<TTPlayerEpisodeUrlModel*> * urls;

@property (nonatomic)                           TTVideoProfile profile;
// 清晰度
@property (nonatomic,strong,getter=getProfiles) NSMutableArray<TTPlayerProfileModel *> *    profiles;

- (void)addProfile:(NSInteger)profile;

- (NSString *)urlDefault;

- (NSString *)urlWithProfile:(NSInteger) profile;

@end

/********************  playerModel ********************/

@interface TTPlayerModel : NSObject
// id
@property (nonatomic)       NSUInteger  movieId;
// 标题
@property (nonatomic,copy)  NSString *  title;
// 当前播放哪集
@property (nonatomic)       NSInteger   episodeIndex;
// 多少个子集
@property (nonatomic)       NSUInteger  episodeCount;
// 当前播放的位置 ,单位 秒
@property (nonatomic)       NSInteger   dutation;
//视频总时长
@property (nonatomic)       NSInteger   movieLength;
// 是否收藏 1 收藏 0 没有收藏
@property (nonatomic)       NSInteger   isFavorite; // 短视频要看剧集里面的
//竖版海报
@property (nonatomic, copy) NSString*   vPosterPath;
@property (nonatomic)       BOOL        isDemo;// 长视频非正片

@property (nonatomic,strong) TTPlayerEpisodeModel * curEpisodeModel;
// 子集 TTPlayerEpisodeModel[]
@property (nonatomic,strong,getter=getEpisodes)     NSMutableArray<TTPlayerEpisodeModel*> * episodes;

- (TTPlayerEpisodeModel *) getEpisodeAtIndex:(NSInteger)index;

@end
