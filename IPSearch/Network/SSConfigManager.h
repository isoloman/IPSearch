//
//  SSNetWorkManager.h
//  shiku_im
//
//  Created by XiaoJunChao on 2019/8/21.
//  Copyright © 2019 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, SSNetWorkType) {
    NetWorkTypeDev,     // 开发服务器地址
    NetWorkTypeTest,     //测试服务器地址
    NetWorkTypeRelease   //发布版服务器地址
};


NS_ASSUME_NONNULL_BEGIN

@interface SSConfigManager : NSObject
/// 一般情况下，返回数据会通过resultCodep判断是否成功，当第三方链接无该参数时，加入此数组则不会被强制走失败回调
@property (nonatomic, strong) NSMutableArray * ignoreUrls;

+ (SSConfigManager *)sharedInstance;

- (void)setManagerBaseUrl:(NSString *)url;
- (void)setNetWorkType:(SSNetWorkType)type;

+ (void)startNetworkMonitoring:(void(^)(void))completeBlock;
+ (void)stopNetworkMonitoring;
+ (BOOL)isNetworkReachable;
+ (AFNetworkReachabilityStatus)getNetworkStatus;

- (void)addRequest:(YTKBaseRequest *)request;
- (void)cancelRequest:(YTKBaseRequest *)request;
- (void)cancelAllRequests;
+ (void)finishRequest;
@end

NS_ASSUME_NONNULL_END
