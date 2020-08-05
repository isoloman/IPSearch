//
//  YCColorManager.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/14.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCColorManager.h"

@implementation YCColorManager

+ (UIColor *)bgColor {
    return  [self colorWithDarkModeColor:[UIColor whiteColor] normalColor:[UIColor whiteColor]];
}

+ (UIColor *)tabbarColor {
    return  [self colorWithDarkModeColor:[UIColor whiteColor] normalColor:[UIColor whiteColor]];
}

+ (UIColor *)IPBGColor {
    return [self colorWithDarkModeColor:YCColor(238, 238, 238) normalColor:YCColor(238, 238, 238)];
//    return  [self colorWithDarkModeColor:YCColor(242, 242, 247) normalColor:YCColor(238, 238, 238)];
}

+(UIColor *)colorWithDarkModeColor:(UIColor *)darkColor normalColor:(UIColor *)color
{
    if (@available(iOS 13.0,*)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleDark) {
                return darkColor;
            }
            else {
                return color;
            }
        }];
        return dyColor;
    }
    return color;
}

@end
