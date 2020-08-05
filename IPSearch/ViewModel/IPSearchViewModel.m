//
//  IPSearchViewModel.m
//  IPSearch
//
//  Created by Gloryyin on 2020/8/4.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "IPSearchViewModel.h"
#import "NSDictionary+Extension.h"

@implementation IPSearchViewModel

+ (void)handleAvailableUrlAddress:(NSString *)ip {
    NSString * url = [NSString stringWithFormat:@"https://ipchaxun.com/%@/",ip];
    
    NSString * baiduUrl = [@"baiduboxapp://v1/browser/open?url=" stringByAppendingString:url];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:baiduUrl]]) {
        url = baiduUrl;
    }
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

+ (void)handleUrlAddress:(NSString *)url {
    
    NSString * baiduUrl = [@"baiduboxapp://v1/browser/open?url=" stringByAppendingString:url];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:baiduUrl]]) {
        url = baiduUrl;
    }
    
    if (@available(iOS 10.0, *)) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

+ (NSString *)changeIPLastComponent:(NSString *)ip {
    NSMutableArray * data = [[ip componentsSeparatedByString:@"."] mutableCopy];
    [data replaceObjectAtIndex:data.count-1 withObject:@"0/24"];
    NSString * ipNew = [data componentsJoinedByString:@"."];
    return ipNew;
}

+ (NSMutableArray *)handleSearchIPResult:(NSArray *)source withIP:(NSString *)ip{
    NSMutableArray * data = [NSMutableArray new];
    [data addObject:@{@"name":@"ip地址",@"addr":ip}];
    
    NSDictionary * dict = source.firstObject;
    NSString * addr = [NSString stringWithFormat:@"%@%@%@%@  %@",[dict getNoNullValue:@"country"],[dict getNoNullValue:@"province"],[dict getNoNullValue:@"city"],[dict getNoNullValue:@"area"],[dict getNoNullValue:@"net"]];
    [data addObject:@{@"name":dict[@"name"],@"addr":addr}];
    //addr为空的不显示,PP中也不需要显示 兼容IPv6地址、映射IPv6地址
    for (int i = 1;i<source.count;i++) {
        if (source.count < i) {
            return data;
        }
        NSDictionary * dic = source[i];
        NSString * value = [dic valueForKey:@"addr"];
        NSString * name = [dic valueForKey:@"name"];
        if (!value||value.length==0||[name isEqualToString:@"邮编"]||[name isEqualToString:@"区号"]) {
            
        }
        else {
            [data addObject:dic];
        }
    }
    
    return data;
}

@end
