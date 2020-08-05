//
//  YCProjectManager.h
//  IPSearch
//
//  Created by Gloryyin on 2020/3/13.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * kSource = @"com.manyou.ios.ipchaxun";

@interface YCProjectManager : NSObject

+ (YCProjectManager *)shareManager;

+ (BOOL)getProxyStatus;

+ (NSString *)getNetType;

+ (NSString *)filterUrl:(NSString *)urlStr;

+ (BOOL)isUrlAddress:(NSString*)url;
+ (BOOL)checkAvailableUrlAddress:(NSString*)url;

//获取网络信号强度（dBm）
+ (int)getSignalStrength;


+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
/* Image 拼接
 * masterImage  主图片
 * headImage   头图片
 * footImage   尾图片
 */
+ (UIImage *)addHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage toMasterImage:(UIImage *)masterImage;

+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size;

+ (UIImage *)snapshotView:(UIView *)view fromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets;

/**
 * 判断字符串是否为IP地址
 * param iPAddress IP地址字符串
 * return BOOL 是返回YES，否返回NO
 */
+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (UIViewController *)getCurrentViewController;


+ (NSArray *)getSearchHistory;
+ (void)removeSearchRecordFormHistory:(NSInteger)index;
+ (BOOL)addSearchRecordToHistory:(NSString *)record;
//+ (void)deleteHistory;
@end

NS_ASSUME_NONNULL_END
