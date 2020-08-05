//
//  SSNetWorkManager.m
//  shiku_im
//
//  Created by XiaoJunChao on 2019/8/21.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "SSConfigManager.h"

@implementation SSConfigManager

- (id)init{
    if ((self = [super init]))
    {
        YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
        [agent setValue:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencodem", @"image/jpeg",@"image/png",@"image/gif",@"application/octet-stream",@"video/mp4",
        @"video/quicktime",nil] forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
  
        AFHTTPSessionManager *sessionManager = [[YTKNetworkAgent sharedAgent] valueForKey:@"_manager"];
        [sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request)
        {
            if (request) {
                return request;
            }
            return nil;
        }];
    }
    return self;
}

+ (SSConfigManager *)sharedInstance{
    static dispatch_once_t once;
    static SSConfigManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[SSConfigManager alloc] init];
    });
    return sharedInstance;
    
}

- (NSMutableArray *)ignoreUrls {
    if (!_ignoreUrls) {
        _ignoreUrls = [NSMutableArray new];
    }
    return _ignoreUrls;
}

- (void)setManagerBaseUrl:(NSString *)url{
    if (url) {
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = url;
    }
}

- (void)setNetWorkType:(SSNetWorkType)type{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    switch (type) {
        case NetWorkTypeDev:     // 开发服务器地址
            config.baseUrl = @"";
            break;
        case NetWorkTypeTest:   // 测试服务器地址
            config.baseUrl = @"";
            break;
        case NetWorkTypeRelease:   // 发布版服务器地址
            config.baseUrl = @"";
            break;
        default:
            break;
    }
    //证书配置
//    [self configHttps];
}

+ (void)configHttps {
    
    // 获取证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ssl_content" ofType:@"pem"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // 配置安全模式
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    //    config.cdnUrl = @"";
    
    // 验证公钥和证书的其他信息
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    // 允许自建证书
    securityPolicy.allowInvalidCertificates = YES;
    
    // 校验域名信息
    securityPolicy.validatesDomainName = YES;
    
    // 添加服务器证书,单向验证;  可采用双证书 双向验证;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    
    [config setSecurityPolicy:securityPolicy];
}

+ (void)startNetworkMonitoring:(void(^)(void))completeBlock {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        completeBlock();
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                //@"当前网络不可用，请检查网络设置";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                // @"2G/3G/4G";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                //                @"WiFi在线";
            }
                
            default:
                break;
        }
    }];
}

+ (void)stopNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (BOOL)isNetworkReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+ (BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+ (AFNetworkReachabilityStatus)getNetworkStatus {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

- (void)addRequest:(YTKBaseRequest *)request{
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];;
    [agent addRequest:request];
}
- (void)cancelRequest:(YTKBaseRequest *)request{
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];;
    [agent cancelRequest:request];
}
- (void)cancelAllRequests{
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];;
    [agent cancelAllRequests];
}

+ (void)finishRequest{
//    AFHTTPSessionManager * manager = [[YTKNetworkAgent sharedAgent] valueForKey:@"_manager"];
//    [manager.session invalidateAndCancel];
}

@end
