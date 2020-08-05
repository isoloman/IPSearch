//
//  YCNetworkRequest.h
//  IPSearch
//
//  Created by Gloryyin on 2020/3/13.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCNetworkRequest : NSObject
///用于显示当前用户的IP及地址数据，APP底部显示
+ (SSBaseRequest *)getCurrentIPInfoWithComplete:(RequestResult)block;
///上传当前用户的经纬度
+ (SSBaseRequest *)uploadLocationWithParam:(NSDictionary *)param Complete:(RequestResult)block;
///查询ip接口
+ (SSBaseRequest *)searchIPInfo:(NSString *)ip withComplete:(RequestResult)block;
///查询rDNS接口
+ (SSBaseRequest *)searchrDNSInfo:(NSString *)ip withComplete:(RequestResult)block;
@end

NS_ASSUME_NONNULL_END
