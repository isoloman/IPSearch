//
//  SSBaseRequest.m
//  shiku_im
//
//  Created by XiaoJunChao on 2019/8/22.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "SSBaseRequest.h"
#import "SSConfigManager.h"
#import "YCErrorManage.h"

@interface SSBaseRequest ()

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, assign) long time;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *Authorization;
@property (nonatomic, copy) NSString *keyUrl;
@property (nonatomic, copy) NSString *key;

@end

@implementation SSBaseRequest

+ (SSBaseRequest *)getWithUrl:(NSString *)url WithParam:(NSDictionary *)param Complete:(RequestResult)block{
    SSBaseRequest *request = [[SSBaseRequest alloc]init];
    request.url = url;
    request.keyUrl = url;
    request.requestType = YTKRequestMethodGET;
    //类似通过appstore连接获取版本号不能够设置这些参数，所以通过ignoreUrls来过滤
    if (![[SSConfigManager sharedInstance].ignoreUrls containsObject:url]) {
        //        [request getSourceType];
        //        [request getTokenAndSecretWith:url];
        request.param = [request getCommonKey:param];
    }
    else {
        request.param = [[NSMutableDictionary alloc] initWithDictionary:param];
    }
    [request startRequestWithResultBlock:block];
    return request;
    
}

+ (SSBaseRequest *)downloadWithUrl:(NSString *)url downloadPath:(NSString *)downloadPath Complete:(RequestResult)block{
    return [self downloadWithUrl:url downloadPath:downloadPath downProgerssProgressBlock:nil Complete:block];
}

+ (SSBaseRequest *)downloadWithUrl:(NSString *)url downloadPath:(NSString *)downloadPath downProgerssProgressBlock:(__nullable UploadProgressBlock)downProgerssBlock Complete:(RequestResult)block{
    SSBaseRequest *request = [[SSBaseRequest alloc]init];
    request.url = url;
    request.keyUrl = url;
    request.requestType = YTKRequestMethodGET;
    request.resumableDownloadPath = downloadPath;
    request.downProgerssBlock = downProgerssBlock;
    //    [request getSourceType];
    //    [request getTokenAndSecretWith:url];
    [request startRequestWithResultBlock:block];
    return request;
    
}

+ (SSBaseRequest *)postWithUrl:(NSString *)url WithParam:(NSDictionary *)param Complete:(RequestResult)block{
    SSBaseRequest *request = [[SSBaseRequest alloc]init];
    request.url = url;
    request.keyUrl = url;
    request.requestType = YTKRequestMethodPOST;
    //    [request getSourceType];
    //    [request getTokenAndSecretWith:url];
    request.param = [request getCommonKey:param];
    [request startRequestWithResultBlock:block];
    
    return request;
}

+ (SSBaseRequest *)upLoadWithUrl:(NSString *)url WithPostPram:(NSDictionary *)postParm WithParam:(NSDictionary *)param Complete:(RequestResult)block Progress:(UploadProgressBlock)problock{
    SSBaseRequest *request = [[SSBaseRequest alloc]init];
    request.url = url;
    request.requestType = YTKRequestMethodPOST;
    request.isUpload = YES;
    request.uploadDataDic = [[NSMutableDictionary alloc]initWithDictionary:param];
    NSUInteger dataLength = 0;
    for (NSString *key in request.uploadDataDic.allKeys) {
        NSData *data = request.uploadDataDic[key];
        dataLength = dataLength + data.length;
    }
    
    request.uploadTimeOut = dataLength / 1024 / 20;
    //    [request getSourceType];
    //    [request getTokenAndSecretWith:url];
    request.param = [request getCommonKey:postParm];
    [request startRequestWithResultBlock:block];
    request.progressBlock = problock;
    
    [request setRequestProgressBlock:request.progressBlock];
    
    return request;
    
}

- (NSMutableDictionary *)getCommonKey:(NSDictionary *)dict{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithCapacity:10];
    [param addEntriesFromDictionary:dict];
    return param;
}


- (void)startRequestWithResultBlock:(RequestResult)resultBlock{
    
    if (![SSConfigManager isNetworkReachable] && [SSConfigManager getNetworkStatus] != AFNetworkReachabilityStatusUnknown) {
        resultBlock(NetWorkResponseNoNetWork,@"无网络");
        return;
    }
    self.ignoreCache = YES;
    YCWeakSelf(self);
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        YCStrongSelf(self);
        NSDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:10];
        dict = [self dictionaryWithJsonString:request.responseString];
        
        resultBlock(NetWorkResponseSuccess,dict);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        resultBlock(NetWorkResponseFailure,request.error);
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark delegate

- (NSString *)baseUrl{
    return @"";
}

- (NSString *)requestUrl{
    return self.url;
}

- (YTKRequestMethod)requestMethod{
    return self.requestType;
}

- (id)requestArgument{
    return self.param;
}

- (NSTimeInterval)requestTimeoutInterval{
    if (self.uploadTimeOut > 0) {
        return self.uploadTimeOut;
    }
    return 30;
}

- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType {
    if ([self.param valueForKey:kResponseSerializerType]) {
        return [self.param[kResponseSerializerType] integerValue];
    }
    return YTKResponseSerializerTypeHTTP;
}

// 返回上传数据类型
- (NSString *) getUploadDataMimeType:(NSString *) key {
    NSString *mimeType = nil;
    key = [key lowercaseString];
    if ([key rangeOfString:@".jpg"].location != NSNotFound || [key rangeOfString:@"image"].location != NSNotFound) {
        mimeType = @"image/jpeg";
    }else if ([key rangeOfString:@".png"].location != NSNotFound) {
        mimeType = @"image/png";
        
    }else if ([key rangeOfString:@".mp3"].location != NSNotFound) {
        mimeType = @"audio/mpeg";
        
    }else if ([key rangeOfString:@".qt"].location != NSNotFound) {
        mimeType = @"video/quicktime";
        
    }else if ([key rangeOfString:@".mp4"].location != NSNotFound) {
        mimeType = @"video/mp4";
        
    }else if ([key rangeOfString:@".amr"].location != NSNotFound) {
        mimeType = @"audio/amr";
    }else if ([key rangeOfString:@".gif"].location != NSNotFound) {
        mimeType = @"image/gif";
    }else if ([key rangeOfString:@".mov"].location != NSNotFound) {
        mimeType = @"video/quicktime";
    }else if ([key rangeOfString:@".wav"].location != NSNotFound) {
        mimeType = @"audio/wav";
    }else {
        mimeType = @"";
    }
    return mimeType;
}

- (AFConstructingBlock)constructingBodyBlock {
    
    if (self.uploadDataDic.allKeys.count == 0) {
        return nil;
    }else{
        return ^(id<AFMultipartFormData> formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            for (NSString *key in self.uploadDataDic.allKeys) {
                NSData *data = self.uploadDataDic[key];
                NSString *mimeType = [self getUploadDataMimeType:key];
                [formData appendPartWithFileData:data name:key fileName:key mimeType:mimeType];
            }
        };
    }
}

#pragma mark 上传进度

- (void)setRequestProgressBlock:(UploadProgressBlock)progressBlock{
    AFHTTPSessionManager * manager = [[YTKNetworkAgent sharedAgent] valueForKey:@"_manager"];
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        CGFloat value = totalBytesSent*1.0/totalBytesExpectedToSend;
        NSLog(@"task %@ progress is %f ", task, totalBytesSent*1.0/totalBytesExpectedToSend);
        if (progressBlock) {
            progressBlock(self, value);
        }
        
    }];
}

- (AFURLSessionTaskProgressBlock)resumableDownloadProgressBlock{
    __weak typeof(self) weakSelf = self;
    AFURLSessionTaskProgressBlock block = ^void(NSProgress * progress){
        if (_downProgerssBlock) {
            CGFloat value = ((CGFloat)progress.completedUnitCount)/progress.totalUnitCount;
            _downProgerssBlock(weakSelf, value);
        }
    };
    return block;
}


- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
    NSDictionary*infoDictionary=[[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString*app_Version=[infoDictionary objectForKey:@"CFBundleShortVersionString"];

    if ([[self.param valueForKey:kNeedUA] boolValue]) {
        return @{@"Content-Type":@"application/json;charset=UTF-8",@"User-Agent":@"ios.ipchaxun.com",@"appVersion":app_Version};
    }
    
    return @{@"Content-Type":@"application/json;charset=UTF-8",@"appVersion":app_Version};
}

@end
