//
//  YCMacros.h
//  Discover
//
//  Created by apple on 2019/9/4.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef YCMacros_h
#define YCMacros_h

#define YCWeakSelf(type) __weak typeof(type) weak##type = type; // weak

#define YCStrongSelf(type) __strong typeof(type) type = weak##type; // strong

// 销毁打印
#define YCDealloc NSLog(@"\n =========+++ %@  销毁了 +++======== \n",[self class])

/// 类型相关
#define YC_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define YC_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define YC_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

/// 屏幕尺寸相关
#define YC_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define YC_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define YC_SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define YC_SCREEN_MAX_LENGTH (MAX(YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT))
#define YC_SCREEN_MIN_LENGTH (MIN(YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT))

#define YC_IS_IPHONE_5          (YC_IS_IPHONE && YC_SCREEN_MAX_LENGTH == 568.0)
#define YC_IS_IPHONE_6          (YC_IS_IPHONE && YC_SCREEN_MAX_LENGTH == 667.0)
#define YC_IS_IPHONE_6P         (YC_IS_IPHONE && YC_SCREEN_MAX_LENGTH == 736.0)
#define YC_IS_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/// 导航条高度
#define YC_APPLICATION_TOP_BAR_HEIGHT (YC_IS_IPHONE_X?88.0f:64.0f)
/// tabBar高度
#define YC_APPLICATION_TAB_BAR_HEIGHT (YC_IS_IPHONE_X?83.0f:49.0f)
/// 工具条高度 (常见的高度)
#define YC_APPLICATION_TOOL_BAR_HEIGHT_44  44.0f
#define YC_APPLICATION_TOOL_BAR_HEIGHT_49  49.0f
#define YC_APPLICATION_BOT_SAFE_HEIGHT  (YC_IS_IPHONE_X?34.0f:.0f)
/// 状态栏高度
#define YC_APPLICATION_STATUS_BAR_HEIGHT (YC_IS_IPHONE_X?44:20.0f)

// KVO获取监听对象的属性 有自动提示
// 宏里面的#，会自动把后面的参数变成c语言的字符串
#define YCKeyPath(objc,keyPath) @(((void)objc.keyPath ,#keyPath))

// 颜色
#define YCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 颜色+透明度
#define YCColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define YCRandomColor YCColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// 根据rgbValue获取对应的颜色
#define YCColorFromRGB(__rgbValue) [UIColor colorWithRed:((float)((__rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((__rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(__rgbValue & 0xFF))/255.0 alpha:1.0]

#define YCColorFromRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//  通知中心
#define YCNotificationCenter [NSNotificationCenter defaultCenter]

// 设置图片
#define YCImageNamed(__imageName) [UIImage imageNamed:__imageName]

// 是否为空对象
#define YCObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define YCStringIsEmpty(__string) ((__string.length == 0) || YCObjectIsNil(__string))

// 字符串不为空
#define YCStringIsNotEmpty(__string)  (!YCStringIsEmpty(__string))

/// AppDelegate
#define YCSharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

/// 适配iPhone X + iOS 11
#define  MHAdjustsScrollViewInsets_Never(__scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([__scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = __scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

#endif /* YCMacros_h */
