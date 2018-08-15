//
//  WWZNetwortReachability.h
//  wwz
//
//  Created by wwz on 16/7/26.
//  Copyright © 2016年 cn.szwwz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WWZ_NETWORK_STATUS_NOTI @"WWZ_NETWORK_STATUS_NOTI"

// 网络类型
typedef NS_ENUM(NSUInteger, WWZNetworkStatus) {
    WWZNetworkStatusNoReachable,//没有网络
    WWZNetworkStatusWWAN,// 手机自带网络
    WWZNetworkStatusWiFi,// WIFI
};

@interface WWZNetwortReachability : NSObject

+ (WWZNetworkStatus)networkStatus;

/**
 开始监控网络
 */
+ (void)startMonitorNetwork;

@end
