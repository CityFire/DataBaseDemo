//
//  TTPlayerModel.m
//  DataBaseDemo
//
//  Created by wjc on 2017/4/13.
//  Copyright © 2017年 CityFire. All rights reserved.
//

#import "TTPlayerModel.h"
#import "KKPlayerControlDefine.h"
#import "UIDevice+Extension.h"

@implementation TTPlayerProfileModel

- (instancetype)initWithProfie:(TTVideoProfile)profile {
    if (self = [super init]) {
        [self setProfile:profile];
    }
    return self;
}

- (void)setProfile:(TTVideoProfile)profile {
    _profile = profile;
    if (_profile == TTVideoProfile240) {
        self.profileName = @"极速";
    }
    else if (_profile == TTVideoProfile320) {
        self.profileName = @"流畅";
    }
    else if (_profile == TTVideoProfile480) {
        self.profileName  = @"标清";
    }
    else if (_profile == TTVideoProfile720) {
        self.profileName  = @"高清";
    }
    else if (_profile == TTVideoProfile1080) {
        self.profileName  = @"超清";
    }
    else {
        self.profileName = @"";
    }
}

@end

// url
@implementation TTPlayerEpisodeUrlModel

@end

// episoce
@implementation TTPlayerEpisodeModel

- (NSMutableArray<TTPlayerEpisodeUrlModel *> *)getUrls {
    if (_urls == nil) {
        _urls = [[NSArray array]mutableCopy];
    }
    return _urls;
}

- (NSMutableArray<TTPlayerProfileModel *> *)getProfiles {
    if (_profiles ==  nil) {
        _profiles = [[NSMutableArray alloc]init];
    }
    return _profiles;
}

- (void)addProfile:(NSInteger)profile {
    for (int i = 0; i  < self.profiles.count; i++) {
        TTPlayerProfileModel *playerProfile = self.profiles[i];
        if (profile == playerProfile.profile) {
            return;
        }
    }
    TTPlayerProfileModel *playerProfile = [[TTPlayerProfileModel alloc]init];
    playerProfile.profile = profile;
    [self.profiles addObject:playerProfile];
    
}

- (NSString *)urlDefault {
    return [self urlWithProfile:-1];
}

- (NSString *)urlWithProfile:(NSInteger) profile {
    return [self urlWithProfile:profile urls:0];
}

// 切换清晰度
- (NSString *)urlWithProfile:(NSInteger) profile urls:(NSInteger)index {
    NSString * url = nil;
    // 获取分段
    if (self.urls.count > 0 && index < self.urls.count) {
        // 默认返回最第一个profile
        if (profile == -1) {
            TTPlayerEpisodeUrlModel *url = self.urls[0];
            self.profile = url.profile;
            return url.url;
        }
        // 寻找合适的清晰度
        for (int i = 0; i < self.urls.count; i++) {
            TTPlayerEpisodeUrlModel *url = self.urls[i];
            if (profile == url.profile) {
                self.profile = url.profile;
                return url.url;
            }
        }
        // 如果没有找到合适的清晰度，
        // 返回最比type低一级的 或者 高一级的
        for (int i = 0; i < self.urls.count; i++) {
            TTPlayerEpisodeUrlModel *url = self.urls[i];
            if (profile - 1 == url.profile) {
                self.profile = url.profile;
                return url.url;
            }
            if (profile + 1 == url.profile) {
                self.profile = url.profile;
                return url.url;
            }
        }
        // 如果没有找到合适的清晰度，
        // 返回最比type低二级的 或者 高二级的
        for (int i = 0; i < self.urls.count; i++) {
            TTPlayerEpisodeUrlModel *url = self.urls[i];
            if (profile + 2 == url.profile) {
                self.profile = url.profile;
                return url.url;
            }
            if (profile - 2 == url.profile) {
                self.profile = url.profile;
                return url.url;
            }
        }
        // 最后还是默认返回第一profile
        TTPlayerEpisodeUrlModel *url = self.urls[0];
        return url.url;
    }
    return url ;
}

- (TTVideoProfile)profile
{
    // 2.被赋值过清晰度
    if (_profile > 0) {
        
        // 当前播放视频有这个清晰度
        for (TTPlayerProfileModel *profileModel in self.profiles) {
            if (profileModel.profile == _profile) {
                
                return _profile;
            }
        }
    }
    
    // 1.先取设置过的profile
    id profileObj = [[NSUserDefaults standardUserDefaults] objectForKey:kkProfileUserDefaultsKey];
    if (profileObj) {
        
        TTVideoProfile profile = [profileObj integerValue];
        // 当前播放视频有这个清晰度
        for (TTPlayerProfileModel *profileModel in self.profiles) {
            if (profileModel.profile == profile) {
                
                return profile;
            }
        }
    }
    
    
    // 3. 选择默认
    TTVideoProfile defulatProfile = [UIDevice isSupportSuperHD] ? TTVideoProfile480 : TTVideoProfile320;
    
    // 当前播放视频有这个清晰度
    for (TTPlayerProfileModel *profileModel in self.profiles) {
        if (profileModel.profile == defulatProfile) {
            
            return defulatProfile;
        }
    }
    
    // 4.选择第一个
    if (self.profiles.count) {
        return [self.profiles firstObject].profile;
    }
    else {
        NSLog(@"当前剧集没有清晰度？");
        
        return TTVideoProfileUnKnow;
    }
}

@end

// playermodel
@implementation TTPlayerModel

- (NSMutableArray<TTPlayerEpisodeModel*> *)getEpisodes {
    if (_episodes == nil) {
        _episodes = [[NSMutableArray alloc] init];
    }
    return _episodes;
}

- (TTPlayerEpisodeModel *) getEpisodeAtIndex:(NSInteger)index {
    if (index < self.episodes.count) {
        return self.episodes[index];
    }
    else {
        return nil;
    }
}

@end
