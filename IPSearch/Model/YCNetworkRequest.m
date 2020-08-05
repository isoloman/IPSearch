//
//  YCNetworkRequest.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/13.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCNetworkRequest.h"

@implementation YCNetworkRequest

+ (SSBaseRequest *)getCurrentIPInfoWithComplete:(RequestResult)block{
 
    SSBaseRequest * request = [SSBaseRequest getWithUrl:@"https://2021.ipchaxun.com/" WithParam:@{kNeedUA:@(YES)} Complete:^(NetWorkResponseType type, id  _Nonnull object) {
        NSLog(@"info = %@",object);
        if (block) {
            block(type,object);
        }
    }];
    
    return request;
    
}

+ (SSBaseRequest *)uploadLocationWithParam:(NSDictionary *)param Complete:(RequestResult)block{
 
    SSBaseRequest * request = [SSBaseRequest getWithUrl:@"https://report.ipchaxun.com/" WithParam:param Complete:^(NetWorkResponseType type, id  _Nonnull object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSLog(@"uploadLocation = %@",[object valueForKey:@"msg"]);
        }
        
        if (block) {
            block(type,object);
        }
    }];
    
    return request;
    
}

+ (SSBaseRequest *)searchIPInfo:(NSString *)ip withComplete:(RequestResult)block{
 
    SSBaseRequest * request = [SSBaseRequest getWithUrl:@"https://www.ip138.com/xml/ip_api2.asp" WithParam:@{kNeedUA:@(YES),@"ip":ip} Complete:^(NetWorkResponseType type, id  _Nonnull object) {
        NSLog(@"search = %@",object);
        if (block) {
            block(type,object);
        }
    }];
    
    return request;
    
}

///查询rDNS接口
+ (SSBaseRequest *)searchrDNSInfo:(NSString *)ip withComplete:(RequestResult)block {
    SSBaseRequest * request = [SSBaseRequest getWithUrl:@"https://rdnsdb.com/api/rdns/" WithParam:@{kNeedUA:@(YES),@"ip":ip} Complete:^(NetWorkResponseType type, id  _Nonnull object) {
        NSLog(@"search = %@",object);
        if (block) {
            block(type,object);
        }
    }];
    
    return request;
}


@end
