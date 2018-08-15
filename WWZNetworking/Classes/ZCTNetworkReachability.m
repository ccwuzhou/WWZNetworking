//
//  ZCTNetworkReachability.m
//  ZCCarOwner
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 zhichekeji. All rights reserved.
//

#import "WWZNetworkReachability.h"
#import <AFNetworking/AFNetworking.h>

static ZCTNetworkStatus _networkStatus = ZCTNetworkStatusNoReachable;

@implementation WWZNetworkReachability

+ (ZCTNetworkStatus)networkStatus{
    return _networkStatus;
}

/**
 开始监控网络
 */
+ (void)startMonitorNetwork{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            case AFNetworkReachabilityStatusNotReachable:{// 没有网络(断网)
//                ZCTLog(@"没有网络");
                _networkStatus = ZCTNetworkStatusNoReachable;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{// 手机自带网络
//                ZCTLog(@"手机自带网络");
                _networkStatus = ZCTNetworkStatusWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{// WIFI
//                ZCTLog(@"WIFI网络");
                _networkStatus = ZCTNetworkStatusWiFi;
            }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCT_NETWORK_STATUS_NOTI object:@(_networkStatus)];
    }];
    [mgr startMonitoring];
//    ZCTLog(@"开始监控网络");
}


@end
