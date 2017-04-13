//
//  UIDevice+XL.h
//  XL
//
//  Created by czh0766 on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    IPOD, IPOD2, IPOD3, IPOD4, IPOD5,
    IPHONE, IPHONE_3G, IPHONE_3GS, IPHONE4, IPHONE_4S, IPHONE5,
    IPAD, IPAD2, NEW_IPAD,
    IOS_SIMULATOR, DEVICE_UNKNOWN
};

@interface UIDevice (Extension)

+(int)deviceModel;
+(NSString *)deviceModelStr;
+(BOOL)isIphone5;
+(BOOL)isSupportSuperHD;
//+(CGFloat)systemVersion;

@end
