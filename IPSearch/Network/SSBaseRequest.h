//
//  SSBaseRequest.h
//  shiku_im
//
//  Created by XiaoJunChao on 2019/8/22.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "YTKNetwork.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NetWorkResponseType) {
    NetWorkResponseNoNetWork = 0,  //  无网络
    NetWorkResponseSuccess,     // 请求成功
    NetWorkResponseFailure //   请求失败
};

typedef void(^RequestResult)(NetWorkResponseType type, id object);
typedef void(^UploadProgressBlock)(YTKBaseRequest *request,CGFloat progress);

static NSString * kResponseSerializerType = @"ResponseSerializerType";
static NSString * kNeedUA = @"NeedUA";

@interface SSBaseRequest : YTKRequest

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableDictionary *uploadDataDic;
@property (nonatomic, assign) YTKRequestMethod requestType;
@property (nonatomic, assign) BOOL isUpload;
@property (nonatomic, assign) NSInteger uploadTimeOut;
@property (nonatomic, copy) RequestResult resultBlock;
@property (nonatomic, copy) UploadProgressBlock progressBlock;
@property (nonatomic, copy) UploadProgressBlock downProgerssBlock;

+ (SSBaseRequest *)postWithUrl:(NSString *)url WithParam:(NSDictionary *)param Complete:(RequestResult)block;
+ (SSBaseRequest *)getWithUrl:(NSString *)url WithParam:(NSDictionary *)param Complete:(RequestResult)block;
+ (SSBaseRequest *)downloadWithUrl:(NSString *)url downloadPath:(NSString *)downloadPath Complete:(RequestResult)block;
+ (SSBaseRequest *)downloadWithUrl:(NSString *)url downloadPath:(NSString *)downloadPath downProgerssProgressBlock:(__nullable UploadProgressBlock)downProgerssBlock Complete:(RequestResult)block;
+ (SSBaseRequest *)upLoadWithUrl:(NSString *)url WithPostPram:(NSDictionary *)postParm WithParam:(NSDictionary *)param Complete:(RequestResult)block Progress:(__nullable UploadProgressBlock)problock;
+(NSString *)getMD5String:(NSString *)s;

- (void)setResultBlock:(RequestResult _Nonnull)resultBlock;

@end

NS_ASSUME_NONNULL_END
