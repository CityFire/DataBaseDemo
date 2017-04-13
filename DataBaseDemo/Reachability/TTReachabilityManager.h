//
//  KKReachabilityManager.h
//  iKanKan
//
//  Created by 朱国清 on 16/3/15.
//  Copyright © 2016年 Nesound Kankan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTReachability.h"

@interface TTReachabilityManager : NSObject

+(TTReachabilityManager *)sharedInstance;

@property (nonatomic,getter=getNetworkStatus) TTNetworkStatus networkStatus;

 @end
