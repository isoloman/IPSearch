//
//  YCLocationManager.h
//  shiku_im
//
//  Created by apple on 2019/8/26.
//  Copyright © 2019 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCLocationManager : NSObject <YCLocationDelegate>
/******定位相关********/
@property(assign) double latitude;
@property(assign) double longitude;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString * countryCode;
@property (nonatomic,strong) NSString * cityName;
@property (nonatomic, copy) NSString *stateName;//省
@property (nonatomic, copy) NSString* country;

@property (nonatomic,assign) int cityId;

@property (nonatomic, strong) YCLocation *location;

+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;

+ (YCLocationManager *)shareManager;

- (void)locate;
@end

NS_ASSUME_NONNULL_END
