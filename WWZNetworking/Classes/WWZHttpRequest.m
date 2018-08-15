
//
//  WWZHttpRequest.m
//  wwz
//
//  Created by wwz on 16/7/19.
//  Copyright © 2016年 cn.szwwz. All rights reserved.
//

#import "WWZHttpRequest.h"
#import <AFNetworking/AFNetworking.h>

static NSInteger const ZCT_CACHE_TOTAL_COST_LIMIT = 100;// 缓存最大数量

static NSTimeInterval const ZCT_TIME_OUT_INTERVAL = 15;//请求超时
static NSTimeInterval const ZCT_CACHE_OVERDUE_SECOND = 180;// 缓存时长

static NSCache *requestCache = nil;// 缓存对象

@implementation WWZUploadParam

+ (instancetype)uploadParamWithData:(NSData *)data
                          paramName:(NSString *)paramName
                           fileName:(NSString *)fileName
                           mineType:(NSString *)mineType{
    return [[self alloc] initWithData:data paramName:paramName fileName:fileName mineType:mineType];
}

- (instancetype)initWithData:(NSData *)data
                   paramName:(NSString *)paramName
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType
{
    self = [super init];
    if (self) {
        _data = data;
        _paramName = paramName;
        _fileName = fileName;
        _mineType = mineType;
    }
    return self;
}

@end

@interface ZCTCacheObject : NSObject

@property (nonatomic, strong) id responseObject;// 缓存数据
@property (nonatomic, assign) NSTimeInterval cacheTimestamp;// 缓存时间戳
@property (nonatomic, assign, readonly) BOOL isOverdue;// 缓存是否过期

@end

@implementation ZCTCacheObject

- (void)setResponseObject:(id)responseObject{
    _responseObject = responseObject;
    _cacheTimestamp = [[NSDate date] timeIntervalSince1970];
}

- (BOOL)isOverdue{
    return [[NSDate date] timeIntervalSince1970] - self.cacheTimestamp > ZCT_CACHE_OVERDUE_SECOND;
}

@end

@implementation WWZHttpRequest

+ (void)initialize
{
    if (self == [WWZHttpRequest class]) {
        requestCache = [[NSCache alloc] init];
        requestCache.totalCostLimit = ZCT_CACHE_TOTAL_COST_LIMIT;
    }
}

+ (void)request:(WWZHttpType)httpType
      urlString:(NSString *)urlString
     parameters:(id)parameters
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure{
    
    [self request:httpType urlString:urlString parameters:parameters isCache:NO success:^(id responseObject, BOOL isCache) {
        if (success) {
            success(responseObject);
        }
    } failure:failure];
}

+ (void)request:(WWZHttpType)httpType
      urlString:(NSString *)urlString
     parameters:(id)parameters
        isCache:(BOOL)isCache
        success:(void (^)(id responseObject, BOOL isCache))success
        failure:(void (^)(NSError *error))failure{
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    mgr.requestSerializer.timeoutInterval = ZCT_TIME_OUT_INTERVAL;
    [mgr.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
    if (httpType == WWZHttpTypeJsonPOST || httpType == WWZHttpTypeJsonGet || httpType == WWZHttpTypePUT) {
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }else{
        
    }
    // 缓存
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", urlString, parameters];
    if (isCache) {
        ZCTCacheObject *cacheObject = [requestCache objectForKey:cacheKey];
        if (cacheObject.responseObject && !cacheObject.isOverdue) {
            // 请求成功
            if (success) {
                success(cacheObject.responseObject, YES);
                return;
            }
        }
    }
    // 成功回调
    void (^successCallBack)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject) {
        // 返回不是字典
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"error": @"数据格式不正确"}];
            if (failure) {
                failure(error);
            }
            return ;
        }
        // 请求成功
        if (success) {
            success(responseObject, NO);
            // 缓存
            if (!isCache) {
                return;
            }
            ZCTCacheObject *cacheObject = [requestCache objectForKey:cacheKey];
            if (cacheObject) {
                cacheObject.responseObject = responseObject;
            }else{
                ZCTCacheObject *cacheObject = [[ZCTCacheObject alloc] init];
                cacheObject.responseObject = responseObject;
                [requestCache setObject:cacheObject forKey:cacheKey];
            }
        }
    };
    // 失败回调
    void (^failureCallBack)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error){
        if (failure) {
            failure(error);
        }
    };
    // 请求
    if (httpType == WWZHttpTypeGET) {// get
        [mgr GET:urlString parameters:parameters progress:nil success:successCallBack failure:failureCallBack];
    }else if (httpType == WWZHttpTypePOST){// post
        [mgr POST:urlString parameters:parameters progress:nil success:successCallBack failure:failureCallBack];
    }else if (httpType == WWZHttpTypePUT){// put
        [mgr PUT:urlString parameters:parameters success:successCallBack failure:failureCallBack];
    }else if (httpType == WWZHttpTypeDELETE){// delete
        [mgr DELETE:urlString parameters:parameters success:successCallBack failure:failureCallBack];
    }else if (httpType == WWZHttpTypeJsonGet){// get
        [mgr GET:urlString parameters:parameters progress:nil success:successCallBack failure:failureCallBack];
    }else if (httpType == WWZHttpTypeJsonPOST){// post
        [mgr POST:urlString parameters:parameters progress:nil success:successCallBack failure:failureCallBack];
    }
}

+ (void)upload:(NSString *)urlString
    parameters:(id)parameters
   uploadParam:(WWZUploadParam *)uploadParam
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    
    [mgr POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.paramName fileName:uploadParam.fileName mimeType:uploadParam.mineType];
    } progress:^(NSProgress *uploadProgress) {
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)clearRequestCache{
    if (requestCache) {
        [requestCache removeAllObjects];
    }
}

@end
