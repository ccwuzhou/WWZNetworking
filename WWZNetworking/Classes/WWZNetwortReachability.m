//
//  WWZNetwortReachability.m
//  wwz
//
//  Created by wwz on 16/7/26.
//  Copyright © 2016年 cn.szwwz. All rights reserved.
//

#import "WWZNetwortReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

static WWZNetworkStatus _networkStatus = WWZNetworkStatusNoReachable;

@implementation WWZNetwortReachability

+ (WWZNetworkStatus)networkStatus{
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
                _networkStatus = WWZNetworkStatusNoReachable;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{// 手机自带网络
                _networkStatus = WWZNetworkStatusWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{// WIFI
                _networkStatus = WWZNetworkStatusWiFi;
            }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WWZ_NETWORK_STATUS_NOTI object:@(_networkStatus)];
    }];
    [mgr startMonitoring];
}

@end
