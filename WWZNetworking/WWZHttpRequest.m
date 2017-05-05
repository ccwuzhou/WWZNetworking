
//
//  WWZHttpRequest.m
//  wwz
//
//  Created by wwz on 16/7/19.
//  Copyright © 2016年 cn.szwwz. All rights reserved.
//

#import "WWZHttpRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation WWZHttpRequest

static NSOperationQueue *_operationQueue = nil;

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    _operationQueue = mgr.operationQueue;
    
    mgr.requestSerializer.timeoutInterval = 15;
    
    [mgr GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _operationQueue = mgr.operationQueue;
    mgr.requestSerializer.timeoutInterval = 15;

    [mgr POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)cancelAllOperations{
    
    if (_operationQueue) {
     
        [_operationQueue cancelAllOperations];
    }
}

@end
