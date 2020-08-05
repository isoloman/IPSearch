//
//  YCAdaption.h
//  shiku_im
//
//  Created by apple on 2019/8/21.
//  Copyright © 2019 Reese. All rights reserved.
//

#ifndef YCAdaption_h
#define YCAdaption_h

#import <UIKit/UIKit.h>

#pragma 屏幕尺寸

#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height

#define IPHONE_X \
({BOOL isPhoneX = NO;\
       if (@available(iOS 11.0, *)) {\
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
        }\
    (isPhoneX);})

#define YCAdaptNaviHeight (IPHONE_X ? 24 : 0) //状态栏高度

#define YCAdaptTabHeight  (IPHONE_X ? 34 : 0) //Tab bar 圆角部分高度

#define YCNAVIHEIGHT      (IPHONE_X ? 88 : 64) //导航

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    #define YC_TEXTSIZE(text, font) [text length] > 0 ? [text \
        sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
    #define YC_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif


#pragma UI设计图尺寸

#define kBaseWidth 375
#define kBaseHeight 667

typedef void(^YCEmptyBlock)(void);

//宏定义内联函数
#define Inline static inline
#pragma mark --设置比例
//实际屏幕宽度和设计图宽度的比例
Inline CGFloat YCAdaptionWidth() {
    return kwidth/kBaseWidth;
}

//传入设计图尺寸标注，转化为实际屏幕尺寸标注
Inline CGFloat YCAdaption(CGFloat x) {
    return x * YCAdaptionWidth();
}
//传入设计图size，转化为实际屏幕的CGsize返回
Inline CGSize YCAdaptionSize(CGFloat width, CGFloat height) {
    CGFloat newWidth = width * YCAdaptionWidth();
    CGFloat newHeight = height * YCAdaptionWidth();
    return CGSizeMake(newWidth, newHeight);
}
//传入设计图Point，转化成CGpoint返回
Inline CGPoint YCAdaptionPoint(CGFloat x, CGFloat y) {
    CGFloat newX = x * YCAdaptionWidth();
    CGFloat newY = y * YCAdaptionWidth();
    return  CGPointMake(newX, newY);
}
//传入设计图Rect，返回已适配真实屏幕的CGrect
Inline CGRect YCAdaptionRect(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
    CGFloat newX = x*YCAdaptionWidth();
    CGFloat newY = y*YCAdaptionWidth();
    CGFloat newW = width*YCAdaptionWidth();
    CGFloat newH = height*YCAdaptionWidth();
    return CGRectMake(newX, newY, newW, newH);
}

Inline CGRect YCAdaptionRectFromFrame(CGRect frame){
    CGFloat newX = frame.origin.x*YCAdaptionWidth();
    CGFloat newY = frame.origin.y*YCAdaptionWidth();
    CGFloat newW = frame.size.width*YCAdaptionWidth();
    CGFloat newH = frame.size.height*YCAdaptionWidth();
    return CGRectMake(newX, newY, newW, newH);
}



//字体适配：传出设计图字体大小
Inline UIFont * YCSystemFont(CGFloat font){
    return [UIFont systemFontOfSize:font*YCAdaptionWidth()];
}
//加粗字体适配
Inline UIFont * YCBoldFont(CGFloat font){
    return [UIFont boldSystemFontOfSize:font*YCAdaptionWidth()];
}

#endif /* YCAdaption_h */
