//
//  NSTimer+TTWeakTimer.m
//  TTKanKan
//
//  Created by wjc on 2017/4/6.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "NSTimer+TTWeakTimer.h"

@implementation NSTimer (TTWeakTimer)

+ (NSTimer *)tt_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    void (^block)() = [inBlock copy];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (NSTimer *)tt_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    void (^block)() = [inBlock copy];
    NSTimer *timer = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (void)__executeTimerBlock:(NSTimer *)inTimer {
    if ([inTimer userInfo]) {
        void (^block)() = (void (^)())[inTimer userInfo];
        if (block) {
            block();
        }
    }
}

@end
