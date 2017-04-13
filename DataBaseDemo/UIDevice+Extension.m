//
//  UIDevice+XL.m
//  XL
//
//  Created by czh0766 on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIDevice+Extension.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Extension)

+(int)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *model = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([model hasPrefix:@"iPod1"]) {
        return IPOD;
    } else if ([model hasPrefix:@"iPod2"]) {
        return IPOD2;
    } else if ([model hasPrefix:@"iPod3"]) {
        return IPOD3;
    } else if ([model hasPrefix:@"iPod4"]) {
        return IPOD4;
    } else if ([model hasPrefix:@"iPod5"]) {
        return IPOD5;
    } else if([model isEqualToString:@"iPhone1,1"]) {
        return IPHONE;
    } else if([model isEqualToString:@"iPhone1,2"]) {
        return IPHONE_3G;
    } else if([model isEqualToString:@"iPhone2,1"]) {
        return IPHONE_3GS;
    } else if([model hasPrefix:@"iPhone3"]) {
        return IPHONE4;
    } else if([model hasPrefix:@"iPhone4"]) {
        return IPHONE_4S;
    } else if ([model hasPrefix:@"iPhone5"]) {
        return IPHONE5;
    } else if([model hasPrefix:@"iPad1"]) {
        return IPAD;
    } else if([model hasPrefix:@"iPad2"]) {
        return IPAD2;
    } else if([model hasPrefix:@"iPad3"] || [model hasPrefix:@"iPad4"]) {
        return NEW_IPAD;
    } else if([model isEqualToString:@"i386"]) {
        return IOS_SIMULATOR;
    } else if([model isEqualToString:@"x86_64"]) {
        return IOS_SIMULATOR;
    }
    
    return DEVICE_UNKNOWN;
}

+(NSString *)deviceModelStr {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSRange range = [deviceModel rangeOfString:@","];
    if (range.location != NSNotFound) {
        deviceModel = [deviceModel stringByReplacingOccurrencesOfString:@"," withString:@"_"];
    }
    
    return deviceModel;
}

+(BOOL)isIphone5 {
    return (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO));
}

//是否支持1080P清晰度
+(BOOL)isSupportSuperHD
{
    int device = [UIDevice deviceModel];
    return (device != IPOD)
    && (device != IPOD2)
    && (device != IPOD3)
    && (device != IPOD4)
    && (device != IPOD5)
    && (device != IPHONE)
    && (device != IPHONE_3G)
    && (device != IPHONE_3GS)
    && (device != IPHONE4)
    && (device != IPHONE_4S)
    && (device != IPAD)
    && (device != IOS_SIMULATOR);
}

@end
