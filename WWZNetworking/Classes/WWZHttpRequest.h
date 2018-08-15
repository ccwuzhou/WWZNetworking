//
//  WWZHttpRequest.h
//  wwz
//
//  Created by wwz on 16/7/19.
//  Copyright © 2016年 cn.szwwz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WWZHttpType) {
    WWZHttpTypeGET,
    WWZHttpTypePOST,
    WWZHttpTypePUT,
    WWZHttpTypeDELETE,
    WWZHttpTypeJsonGet,
    WWZHttpTypeJsonPOST,
};

@interface WWZUploadParam : NSObject
/**
 *  上传文件
 */
@property (nonatomic, strong) NSData *data;
/**
 *  文件参数名，必须与服务器一致
 */
@property (nonatomic, copy) NSString *paramName;
/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  上传文件类型
 */
@property (nonatomic, copy) NSString *mineType;

/**
 *  上传模型
 *
 *  @param data      上传文件
 *  @param paramName 文件参数名，必须与服务器一致
 *  @param fileName  文件名
 *  @param mineType  上传文件类型
 *
 *  @return WZUploadParam
 */
+ (instancetype)uploadParamWithData:(NSData *)data
                          paramName:(NSString *)paramName
                           fileName:(NSString *)fileName
                           mineType:(NSString *)mineType;

@end

@interface WWZHttpRequest : NSObject

/**
 发送请求
 
 @param httpType   请求类型
 @param urlString  请求的基本的url
 @param parameters 请求的参数字典
 @param success    请求成功的回调
 @param failure    请求失败的回调
 */
+ (void)request:(WWZHttpType)httpType
      urlString:(NSString *)urlString
     parameters:(id)parameters
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;


/**
 发送请求
 
 @param httpType   请求类型
 @param urlString  请求的基本的url
 @param parameters 请求的参数字典
 @param isCache    是否缓存
 @param success    请求成功的回调
 @param failure    请求失败的回调
 */
+ (void)request:(WWZHttpType)httpType
      urlString:(NSString *)urlString
     parameters:(id)parameters
        isCache:(BOOL)isCache
        success:(void (^)(id responseObject, BOOL isCache))success
        failure:(void (^)(NSError *error))failure;

+ (void)upload:(NSString *)urlString
    parameters:(id)parameters
   uploadParam:(WWZUploadParam *)uploadParam
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure;
/**
 清理缓存
 */
+ (void)clearRequestCache;
@end

