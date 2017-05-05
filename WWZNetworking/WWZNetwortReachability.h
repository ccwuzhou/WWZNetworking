//
//  WWZNetwortReachability.h
//  wwz
//
//  Created by wwz on 16/7/26.
//  Copyright © 2016年 cn.szwwz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWZNetwortReachability : NSObject
/**
 *  网络切换检测
 */
+ (void)wwz_networkReachabilityNotReachableBolck:(void(^)())notReachableBlock reachableBlock:(void(^)())reachableBlock;

@end
