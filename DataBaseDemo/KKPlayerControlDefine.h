//
//  KKPlayerControlDefine.h
//  iKanKan
//
//  Created by kankan on 15/12/18.
//  Copyright © 2015年 Nesound Kankan Inc. All rights reserved.
//

#ifndef KKPlayerControlDefine_h
#define KKPlayerControlDefine_h
/*
 详情页与播放器的相互通知
 通知各个字段
 name: 页面到页面的通知key
 objct: NSString 类型 表示下一级通知 具体业务
 userInfo: 是一个字典，约束如下
 userInfo["stringValue"] :  传一个字符串 <NSString>
 userInfo["numberValue"] :  传一个数字  <NSNumber>
 userInfo["objctValue"] :   传一个对象  <id>
 */

/*****************************共用详情页 ************************************/
// >>>>>>>>>>>>>>>>>>>>>>> player
#define  kkCommDetailToPlayer_iPhone @"kkCommDetailToPlayer_iPhone"
/*
 收藏
 userIfno["numberValue"] = select 0 1
 */
#define  kkCommDetailToPlayerFavorite_iPhone @"kkCommDetailToPlayerFavorite_iPhone"
/*
 分享
 */
#define  kkCommDetailToPlayerShare_iPhone @"kkCommDetailToPlayerShare_iPhone"
/*
下载
 */
#define  kkCommDetailToPlayerDownload_iPhone @"kkCommDetailToPlayerDownload_iPhone"
/*
 详情页退出
 */
#define  kkCommDetailToPlayerExit_iPhone @"kkCommDetailToPlayerExit_iPhone"

// <<<<<<<<<<<<<<<<<<<<<<  player
#define  kkCommPlayerToDetail_iPhone @"kkCommPlayerToDetail_iPhone"
/*
 收藏
 userIfno["numberValue"] = select 0 1
 */
#define  kkCommPlayerToDetailFavorite_iPhone @"kkCommPlayerToDetailFavorite_iPhone"



/*****************************看看详情页 ************************************/

// >>>>>>>>>>>>>>>>>>>>>>> player
// 从看看详情页发送通知到看看播放器 的页面key
#define  kkDetailToKKPlayer_iPhone @"kkDetailToKKPlayer_iPhone"
/*
 从KK详情页传播放模型到KK播放器
 userInfo["objectValue"] = TTPlayerModel
 */
#define  kkDetailToKKPlayerPlayerModel_iPhone @"kkDetailToKKPlayerPlayerModel_iPhone"

/*
 选择子集
 userIfno["numberValue"] = selectIndex
 */
#define  kkDetailToKKPlayerEpisodeSelect_iPhone @"kkDetailToKKPlayerEpisodeSelect_iPhone"

/*
 停止播放
 */
#define  kkDetailToKKPlayerUnloadPlayer_iPhone @"kkDetailToKKPlayerUnloadPlayer_iPhone"
/*
 添加子集数据
 */
#define  kkDetailToKKPlayerAppendEpisodes_iPhone @"kkDetailToKKPlayerAppendEpisodes_iPhone"


// <<<<<<<<<<<<<<<<<<<<<<<<< player
//从看看播放器发送通知到看看详情页 的页面key
#define  kkPlayerToKKDetial_iPhone @"kkPlayerToKKDetial_iPhone"
/*
 选择子集
 userIfno["numberValue"] = selectIndex
 */
#define  kkPlayerToKKDetialPlaySelect_iPhone @"kkPlayerToKKDetialPlaySelect_iPhone"



/*******************************Vip详情页******************************/

// >>>>>>>>>>>>>>>>>>>>>>> player
// 从Vip详情页发送通知到看看播放器 的页面key
#define  kkVipDetailToVipPlayer_iPhone @"kkVipDetailToVipPlayer_iPhone"
/*
 从VIP详情页传播放模型到Vip播放器
 userInfo["objectValue"] = TTPlayerModel
 */
#define  kkVipDetailToVipPlayerPlayerModel_iPhone @"kkVipDetailToVipPlayerPlayerModel_iPhone"

/*
 选择子集
 userIfno["numberValue"] = selectIndex
 */
#define  kkVipDetailToVipPlayerEpisodeSelect_iPhone @"kkVipDetailToVipPlayerEpisodeSelect_iPhone"
/*
 停止播放
 */
#define  kkVipDetailToVipPlayerUnLoadPlayer_iPhone @"kkVipDetailToVipPlayerUnLoadPlayer_iPhone"


// <<<<<<<<<<<<<<<<<<<<<<<<< player
//从vip播放器发送通知到vip详情页的页面key
#define  kkvipPlayerTovipDetial_iPhone @"kkvipPlayerTovipDetial_iPhone"
/*
 选择子集
 userIfno["numberValue"] = selectIndex
 */
#define  kkvipPlayerTovipDetialPlaySelect_iPhone @"kkvipPlayerTovipDetialPlaySelect_iPhone"




/*******************************本地详情页******************************/

// >>>>>>>>>>>>>>>>>>>>>>> player
// 从本地详情页发送通知到看看播放器 的页面key
#define  kkLocalDetailToLocalPlayer_iPhone @"kkLocalDetailToLocalPlayer_iPhone"
/*
 从本地详情页传播放模型到Vip播放器
 userInfo["objectValue"] = TTPlayerModel
 */
#define  kkLocalDetailToLocalPlayerPlayerModel_iPhone @"kkLocalDetailToLocalPlayerPlayerModel_iPhone"


// <<<<<<<<<<<<<<<<<<<<<<<<< player
//从vip播放器发送通知到vip详情页的页面key

// <<<<<<<<<<<<<<<<<<<<<<<<< player
// 用户选择了清晰度 存在本地的key
#define kkProfileUserDefaultsKey  @"kkProfileUserDefaultsKey"
#endif /* KKPayerControlDefine_h */
