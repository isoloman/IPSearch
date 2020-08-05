//
//  NSLayoutConstraint+YCIBDesignable.m
//  shiku_im
//
//  Created by apple on 2019/8/23.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "NSLayoutConstraint+YCIBDesignable.h"

#import <objc/runtime.h>

// 基准屏幕宽度
#define kRefereWidth 375.0
// 以屏幕宽度为固定比例关系，来计算对应的值。假设：基准屏幕宽度375，floatV=10；当前屏幕宽度为750时，那么返回的值为20
#define AdaptW(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.width/kRefereWidth)

#define Ad_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define k_AdaptNaviHeight (IPHONE_X ? 24 : 0)
#define k_AdaptBotSafeHeight (IPHONE_X ? 34 : 0)

@implementation NSLayoutConstraint (YCIBDesignable)

//定义常量 必须是C语言字符串
static char * kYCAdapterScreenKey = "kYCAdapterScreenKey";

static char * kYCIsIPhoneKey = "kYCIsIPhoneKey";

static char * kYCAdapterHeight = "kYCAdapterHeight";

- (BOOL)adapterScreen{
    NSNumber *number = objc_getAssociatedObject(self, kYCAdapterScreenKey);
    return number.boolValue;
}

- (void)setAdapterScreen:(BOOL)adapterScreen {
    
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, kYCAdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterScreen){
        self.constant = AdaptW(self.constant);
    }
}

- (void)setIs_adapterIPhoneX:(BOOL)is_iPhoneX{
    NSNumber *number = @(is_iPhoneX);
    objc_setAssociatedObject(self, kYCIsIPhoneKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.is_adapterIPhoneX&&Ad_IPHONE_X) {
        if (self.firstAttribute == NSLayoutAttributeTop) {
            self.constant += k_AdaptNaviHeight;
        }
        else if (self.firstAttribute == NSLayoutAttributeBottom){
            self.constant += k_AdaptBotSafeHeight;
        }
    }
}

- (BOOL)is_adapterIPhoneX{
    NSNumber *number = objc_getAssociatedObject(self, kYCIsIPhoneKey);
    return number.boolValue;
}

- (CGFloat)adapterHeight{
    NSNumber *number = objc_getAssociatedObject(self, kYCAdapterHeight);
    return number.floatValue;
}

- (void)setAdapterHeight:(CGFloat)adapterHeight {
    NSNumber *number = @(adapterHeight);
    objc_setAssociatedObject(self, kYCAdapterHeight, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (adapterHeight != 0&&Ad_IPHONE_X){
        self.constant += adapterHeight;
    }
}

@end
