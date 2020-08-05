//
//  YCLocationManager.m
//  shiku_im
//
//  Created by apple on 2019/8/26.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "YCLocationManager.h"
#import "YCLocation.h"
#import "YCNetworkRequest.h"
#import "YCProjectManager.h"

@implementation YCLocationManager {
    bool _isShowAlert;
}

static YCLocationManager *sharedManager = nil;

+ (YCLocationManager *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YCLocationManager alloc] init];
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

- (void)locate {
    // 判断定位操作是否被允许
    [self getLocationPermissionVerifcationWithController];
}

- (YCLocation *)location {
    if (!_location) {
        YCLocation *location = [[YCLocation alloc] init];
        location.delegate = self;
        _location = location;
    }
    
    return _location;
}

#pragma mark YCLocationDelegate
- (void)location:(YCLocation *)location CountryCode:(NSString *)countryCode StateName:(NSString *)stateName CityName:(NSString *)cityName CityId:(NSString *)cityId Address:(NSString *)address Latitude:(double)lat Longitude:(double)lon{
    [YCLocationManager shareManager].countryCode = countryCode;
    [YCLocationManager shareManager].cityName = cityName;
    [YCLocationManager shareManager].cityId = [cityId intValue];
    [YCLocationManager shareManager].address = address;
    [YCLocationManager shareManager].latitude = lat;
    [YCLocationManager shareManager].longitude = lon;
    [YCLocationManager shareManager].stateName = stateName;
    [YCLocationManager shareManager].country = self.location.country;
    [self uploadLocation];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
}

- (void)stopUpdatingLocation {
    
}

- (void)location:(YCLocation *)location getLocationError:(NSError *)error {
    
//    if(self.isAutoLogin && !YC_Project_StringNull(_myToken))
    
}
/**
 lng经度
 lat纬度
 network 网络类型，默认为空
 vpn 0未知 、1非VPN、2VPN，默认0
 source 来源，用包名
 */
- (void)uploadLocation {
    NSString * type = [YCProjectManager getNetType];
    if ([type isEqualToString:@"无网络"]) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary new];
    [param setValue:@(self.latitude) forKey:@"lat"];
    [param setValue:@(self.longitude) forKey:@"lng"];
    [param setValue:[type lowercaseString] forKey:@"network"];
    [param setValue:kSource forKey:@"source"];
    [param setValue:@([YCProjectManager getProxyStatus]+1) forKey:@"vpn"];
    [param setValue:@(YES) forKey:kNeedUA];
    [YCNetworkRequest uploadLocationWithParam:param Complete:^(NetWorkResponseType type, id  _Nonnull object) {
        NSLog(@"uploadLocation = %@",object);
    }];
}

#pragma mark - ****************************** 获取位置验证权限
/**
 获取位置验证权限(作用域: 地图 & 定位相关)
 */
- (void)getLocationPermissionVerifcationWithController {
    BOOL enable = [CLLocationManager locationServicesEnabled];
    NSInteger state = [CLLocationManager authorizationStatus];
    
    if (2 > state) {// 尚未授权位置权限
        if (8 <= [[UIDevice currentDevice].systemVersion floatValue]) {
            NSLog(@"系统位置权限授权弹窗");
            [self.location locationStart];
           
        }
    }
    else {
        if (state == kCLAuthorizationStatusDenied||!enable) {// 授权位置权限被拒绝
            NSLog(@"授权位置权限被拒绝");
            NSString * msg = !enable ? @"需要到设置->隐私->定位服务 开启定位才能使用":@"需要访问位置权才能使用";
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示"
                                                                              message:msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
            
            [alertCon addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_after(0.2, dispatch_get_main_queue(), ^{
                    
                    _isShowAlert = NO;
                    
                    if (@available(ios 10.0,*)) { //iOS10以后,使用新API
                        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
//                        if (!enable) {
//                            url = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION"];
//                        }
                        if ([[UIApplication sharedApplication ]canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            }];
                        }
                        
                    }else { //iOS10以前,使用旧API
                        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];//跳转至系统定位授权
//                        if (!enable) {
//                            url = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION"];
//                        }
                        
                        if ([[UIApplication sharedApplication ]canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                    
                });
            }]];
            if (!_isShowAlert) {
                [[YCProjectManager getCurrentViewController] presentViewController:alertCon animated:YES completion:^{
                    _isShowAlert = YES;
                }];
                
            }
            
        }
        else if (state > 2) {
            [[YCProjectManager getCurrentViewController] dismissViewControllerAnimated:YES completion:nil];
            _isShowAlert = NO;
            [self.location locationStart];
        }
    }
}
@end
