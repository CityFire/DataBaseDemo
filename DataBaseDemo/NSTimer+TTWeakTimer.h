//
//  NSTimer+TTWeakTimer.h
//  TTKanKan
//
//  Created by wjc on 2017/4/6.
//  Copyright © 2017年 kankan. All rights reserved.
//  避免循环引用

#import <Foundation/Foundation.h>

@interface NSTimer (TTWeakTimer)

+ (NSTimer *)tt_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

+ (NSTimer *)tt_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
