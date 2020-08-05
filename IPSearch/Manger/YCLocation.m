//
//  YCLocation.m
//  shiku_im
//
//  Created by p on 2017/4/1.
//  Copyright © 2017年 Reese. All rights reserved.
//

#import "YCLocation.h"

@interface YCLocation ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *location;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation YCLocation

- (instancetype)init {
    if (self = [super init]) {
        
        _location = [[CLLocationManager alloc] init] ;
        _location.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //            [_location requestAlwaysAuthorization];//始终允许访问位置信息,必须关闭
            [_location requestWhenInUseAuthorization];//使用应用程序期间允许访问位置数据
        }
    }
    
    return self;
}

- (void)locationStart {
    [_location startUpdatingLocation];
    [_location stopUpdatingHeading];
}

#pragma mark -------------获取经纬度----------------
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    double latitude  =  currentLocation.coordinate.latitude;
    double longitude =  currentLocation.coordinate.longitude;
    NSLog(@"成功获得位置:latitude:%f,longitude:%f",latitude,longitude);
    
    //根据经纬度反向地理编译出地址信息
    [self getAddressInfo:currentLocation];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    if (_delegate && [_delegate respondsToSelector:@selector(stopUpdatingLocation)]) {
        [_delegate stopUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"成功获得状态");
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"找不到位置: %@", [error description]);
    return;
}

- (void)getAddressInfo:(CLLocation *)location{
    //    37.422729, -106.000207
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    [self reverseGeocode:location];
}

// 国内反编码
- (void) reverseGeocode:(CLLocation *)location{
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            
            //            NSLog(@"placeMark:%@\n name:%@\n thoroughfare:%@\n subThoroughfare:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n postalCode:%@\n ISOcountryCode:%@\n country:%@\n inlandWater:%@\n ocean:%@\n areasOfInterest:%@",placeMark.addressDictionary,placeMark.name,placeMark.thoroughfare,placeMark.subThoroughfare,placeMark.locality,placeMark.subLocality,placeMark.administrativeArea,placeMark.subAdministrativeArea,placeMark.postalCode,placeMark.ISOcountryCode,placeMark.country,placeMark.inlandWater,placeMark.ocean,placeMark.areasOfInterest);
            
            //获取城市名
            NSString *city = placeMark.locality;
            if (!city) {    //四大直辖市的城市信息可能无法通过locality获得，可通过获取省份的方法来获得
                city = placeMark.administrativeArea;
            }
            if (city) {
                self.cityName = city;
            }
            
            
            //获取国家代号（当前所在国家代号，区分国内国外重要依据）
            self.countryCode = placeMark.ISOcountryCode;
//            self.countryCode = @"MY";
            
            
            //从 placeMark.addressDictionary 获取详细地址信息
            NSDictionary *addressDict = placeMark.addressDictionary;
            //            NSLog(@"addressDict:%@",addressDict);
            if ([addressDict objectForKey:@"Country"]) {
                _country = [addressDict objectForKey:@"Country"];
            }
            //详细地址
            NSString *addressStr = [addressDict objectForKey:@"Name"];
            //去掉国家名
            if (addressStr.length&&placeMark.country.length) {
                addressStr = [addressStr stringByReplacingOccurrencesOfString:placeMark.country withString:@""];
            }
            //如果有州或省名，去掉之
            if ([addressDict objectForKey:@"State"] != nil) {
                _stateName = [addressDict objectForKey:@"State"];
                if (addressStr.length)
                   addressStr = [addressStr stringByReplacingOccurrencesOfString:[addressDict objectForKey:@"State"] withString:@""];
            }
            
            if (_address) {
                //                [_address release];
                _address = nil;
            }
            _address = [[NSString alloc] initWithFormat:@"%@%@",self.cityName,addressStr];
            
            if ([self.delegate respondsToSelector:@selector(location:CountryCode:StateName:CityName:CityId:Address:Latitude:Longitude:)]) {
                [self.delegate location:self CountryCode:self.countryCode StateName:_stateName CityName:self.cityName CityId:self.cityId Address:self.address Latitude:location.coordinate.latitude Longitude:location.coordinate.longitude];
            }
            
            //            NSLog(@"登录地址:%@ countryCode:%@ city:%@ cityId:%d",_address,self.countryCode,_cityName,_cityId);
            
            //            if (isLogin || _isGetSetting) {
            //                [self getSetting:self];
            //            }
            
            //            [g_App.mainVc changeUserCityId];
        }else {
            
        }
    }];
}





@end
