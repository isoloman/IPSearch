//
//  YCProjectManager.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/13.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCProjectManager.h"
#import "LDNetGetAddress.h"
#import "RealReachability.h"
#import <CoreTelephony/CTCarrier.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static NSString * SearchHistoryFilePath = @"SearchHistoryFilePath";//搜索历史记录存放路径

@implementation YCProjectManager

static YCProjectManager *sharedManager = nil;

+ (YCProjectManager *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YCProjectManager alloc] init];
    });
    
    return sharedManager;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [super allocWithZone:zone];
    });
    return sharedManager;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return sharedManager;
}

+ (BOOL)getProxyStatus {
    
//    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
//    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
//    NSDictionary *settings = [proxies objectAtIndex:0];
//
//    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
//    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
//    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
//
//    BOOL isVPNOn = NO;
//    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
//        //没有设置代理
//        NSLog(@"none 没有设置代理");
//        isVPNOn = NO;
//    }else{
//        //设置代理了
//        NSLog(@"yes 设置代理了");
//        isVPNOn = YES;
//    }
    
    return  [RealReachability sharedInstance].isVPNOn;
}

+ (NSString *)getNetType{
    
    NSString *netconnType = @"";
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    switch (status) {
        case RealStatusNotReachable:
        {
        //  case NotReachable handler
            NETWORK_TYPE type = [LDNetGetAddress getNetworkTypeFromStatusBar];
            if (type == NETWORK_TYPE_NONE) {
                netconnType = @"无网络";
            }
            else if (type == NETWORK_TYPE_WIFI) {
//                netconnType = [@"Wifi" stringByAppendingString:@"(网络差)"];
                netconnType = @"Wifi";
            }
            else {
//                netconnType = [[self getWWANType] stringByAppendingString:@"(网络差)"];
                netconnType = [self getWWANType];
            }
            
            break;
        }
            
        case RealStatusViaWiFi:
        {
        //  case WiFi handler
            netconnType = @"Wifi";
            break;
        }
            
        case RealStatusViaWWAN:
        {
        //  case WWAN handler
            netconnType = [self getWWANType];
            break;
        }
            
        default:
            break;

    }
    
    return netconnType;
}

+ (NSString *)getWWANType {
    // 获取手机网络类型
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *currentStatus = info.currentRadioAccessTechnology;
    
    NSString *netconnType = @"";
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        
        netconnType = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        
        netconnType = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        
        netconnType = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        
        netconnType = @"2G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        netconnType = @"4G";
    }
    
    return netconnType;
}

//获取网络信号强度（dBm）
+ (int)getSignalStrength{
    if (YC_IS_IPHONE_X) {
        id statusBar = [[UIApplication sharedApplication] valueForKeyPath:@"statusBar"];
        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
        int signalStrength = 0;
        
        NSArray *subviews = [[foregroundView subviews][2] subviews];
        
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                signalStrength = [[subview valueForKey:@"numberOfActiveBars"] intValue];
                break;
            }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                signalStrength = [[subview valueForKey:@"numberOfActiveBars"] intValue];
                break;
            }
        }
        return signalStrength;
    } else {
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
        NSString *dataNetworkItemView = nil;
        int signalStrength = 0;
        
        NETWORK_TYPE type = [LDNetGetAddress getNetworkTypeFromStatusBar];
        
        for (id subview in subviews) {
            
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]] && type == NETWORK_TYPE_WIFI  && type != NETWORK_TYPE_WIFI) {
                dataNetworkItemView = subview;
                signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
                break;
            }
            if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]] && type != NETWORK_TYPE_WIFI && type != NETWORK_TYPE_WIFI) {
                dataNetworkItemView = subview;
                signalStrength = [[dataNetworkItemView valueForKey:@"_signalStrengthRaw"] intValue];
                break;
            }
        }
        return signalStrength;
    }
}


+ (NSString *)filterUrl:(NSString *)urlStr {
    NSArray * array;
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * url = [urlStr lowercaseString];
    if ([url containsString:@"http://"]) {
        array = [url componentsSeparatedByString:@"http://"];
        
    }
    else if ([url containsString:@"https://"]) {
        array = [url componentsSeparatedByString:@"https://"];
    }
    array = [array.lastObject componentsSeparatedByString:@"/"];
    if (array.count) {
        return array.firstObject;
    }
    
    return url;
}

+ (BOOL)isUrlAddress:(NSString*)url
{
    NSString*reg =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSPredicate*urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];

    return [urlPredicate evaluateWithObject:url];

}

+ (BOOL)checkAvailableUrlAddress:(NSString*)url {
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![[url lowercaseString] containsString:@"http"]&&![[url lowercaseString] containsString:@"https"]) {
        url = [@"https://" stringByAppendingString:url];
    }
    
    return [self isUrlAddress:[url lowercaseString]];
}

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    CGRect  savedFrame = scrollView.frame;
    CGSize size = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height);
    if(&UIGraphicsBeginImageContextWithOptions != NULL){
        //第一个参数表示区域大小。第二个参数表示透明开关，如果图形完全不用透明，设置为YES以优化位图的存储.第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    }
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    //iOS7 提供的截屏新方法，可以不在主线程做
    [scrollView drawViewHierarchyInRect:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    scrollView.frame = savedFrame;
    if(image != nil){
        return image;
    }
    return nil;
}

/* Image 拼接
 * masterImage  主图片
 * headImage   头图片
 * footImage   尾图片
 */
+ (UIImage *)addHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage toMasterImage:(UIImage *)masterImage {
    
    CGSize size;
    size.width = masterImage.size.width;
    
    CGFloat headHeight = !headImage? 0:headImage.size.height/2.0;
    CGFloat footHeight = !footImage? 0:footImage.size.height/2.0;
    
    size.height = masterImage.size.height + headHeight + footHeight;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    if (headImage)
        [headImage drawInRect:CGRectMake(0, 0, masterImage.size.width, headHeight)];
    
        
    [masterImage drawInRect:CGRectMake(0, headHeight, masterImage.size.width, masterImage.size.height)];
    
    if (footImage)
        [footImage drawInRect:CGRectMake(0, masterImage.size.height + headHeight, masterImage.size.width, footHeight)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
    
}

+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    /**
     1.第一个参数表示区域大小
     2.第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES
     3.第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale
     */
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    //渲染view.layer
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    //保存图片到照片库
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}

/**
     snapshotFrame 想要截取屏幕的frame
     */
+ (UIImage *)snapshotView:(UIView *)view fromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(currentContext, - CGRectGetMinX(rect), - CGRectGetMinY(rect));
    [view.layer renderInContext:currentContext];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:rect];
    snapshotView.image = [snapshotImage resizableImageWithCapInsets:capInsets];
    //保存图片到照片库
    UIImageWriteToSavedPhotosAlbum(snapshotView.image, nil, nil, nil);
    return snapshotView.image;
}

/**
 * 判断字符串是否为IP地址
 * param iPAddress IP地址字符串
 * return BOOL 是返回YES，否返回NO
 */

+ (BOOL)isValidatIP:(NSString *)ipAddress{
    
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    
    return NO;
}

+ (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    // 获取默认的window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到它。
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取window的rootViewController
    result = window.rootViewController;
    result =[self getVisibleViewControllerFrom:result];
    return result;
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

+ (void)removeSearchRecordFormHistory:(NSInteger)index{
    NSMutableArray * records = [[NSMutableArray alloc]initWithArray:[YCStorage readDataFromFilepath:SearchHistoryFilePath]];
    if (index < records.count)
        [records removeObjectAtIndex:index];
    
    [YCStorage writeData:records toFilepath:SearchHistoryFilePath];
}

+ (BOOL)addSearchRecordToHistory:(NSString *)record{
    NSMutableArray * records = [[NSMutableArray alloc]initWithArray:[YCStorage readDataFromFilepath:SearchHistoryFilePath]];
    
    if ([records containsObject:record]||record.length<=0) {
        return NO;
    }
    
    if (records.count == 5) {
        [records removeLastObject];
        
    }
    [records insertObject:record atIndex:0];
    
    [YCStorage writeData:records toFilepath:SearchHistoryFilePath];
    
    return YES;
}


+ (NSArray *)getSearchHistory{
    NSArray * records = [YCStorage readDataFromFilepath:SearchHistoryFilePath];
    return records;
}

@end
