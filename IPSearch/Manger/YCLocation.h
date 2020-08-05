//
//  YCLocation.h
//  shiku_im
//
//  Created by p on 2017/4/1.
//  Copyright © 2017年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class YCLocation;
@protocol YCLocationDelegate <NSObject>

// 定位后返回地理信息
- (void) location:(YCLocation *)location CountryCode:(NSString *)countryCode StateName:(NSString *)stateName CityName:(NSString *)cityName CityId:(NSString *)cityId Address:(NSString *)address Latitude:(double)lat Longitude:(double)lon;
@optional
- (void)stopUpdatingLocation;
- (void)location:(YCLocation *)location getLocationError:(NSError *)error;

@end

@interface YCLocation : NSObject

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *stateName;//省
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString* countryId;
@property (nonatomic, copy) NSString* provinceId;
@property (nonatomic, copy) NSString* areaId;
@property (nonatomic, copy) NSString* country;

@property (nonatomic, weak) id<YCLocationDelegate> delegate;

// 开始定位
- (void) locationStart;



@end
