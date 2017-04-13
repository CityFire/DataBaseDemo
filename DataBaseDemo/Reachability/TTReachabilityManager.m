//
//  KKReachabilityManager.m
//  iKanKan
//
//  Created by 朱国清 on 16/3/15.
//  Copyright © 2016年 Nesound Kankan Inc. All rights reserved.
//

#import "TTReachabilityManager.h"

@interface TTReachabilityManager() {
    TTReachability * _objReachability;
}
@end

@implementation TTReachabilityManager

+ (TTReachabilityManager *)sharedInstance {
    static TTReachabilityManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TTReachabilityManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self=[super init]) {
        _objReachability = [TTReachability reachabilityForInternetConnection];
        [_objReachability startNotifier];
    }
    return self;
}

- (TTNetworkStatus)getNetworkStatus {
    return [_objReachability currentReachabilityStatus];
}

@end
