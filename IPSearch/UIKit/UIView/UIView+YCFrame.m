//
//  UIView+ycFrame.m
//  ycDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIView+YCFrame.h"

@implementation UIView (YCFrame)

- (void)setYc_x:(CGFloat)yc_x
{
    CGRect frame = self.frame;
    frame.origin.x = yc_x;
    self.frame = frame;
}
- (CGFloat)yc_x
{
    return self.frame.origin.x;
}


- (void)setYc_y:(CGFloat)yc_y
{
    CGRect frame = self.frame;
    frame.origin.y = yc_y;
    self.frame = frame;
}
- (CGFloat)yc_y
{
    return self.frame.origin.y;
}


- (void)setYc_centerX:(CGFloat)yc_centerX
{
    CGPoint center = self.center;
    center.x = yc_centerX;
    self.center = center;
}
- (CGFloat)yc_centerX
{
    return self.center.x;
}



- (void)setYc_centerY:(CGFloat)yc_centerY
{
    CGPoint center = self.center;
    center.y = yc_centerY;
    self.center = center;
}
- (CGFloat)yc_centerY
{
    return self.center.y;
}




- (void)setYc_width:(CGFloat)yc_width
{
    CGRect frame = self.frame;
    frame.size.width = yc_width;
    self.frame = frame;
}
- (CGFloat)yc_width
{
    return self.frame.size.width;
}





- (void)setYc_height:(CGFloat)yc_height
{
    CGRect frame = self.frame;
    frame.size.height = yc_height;
    self.frame = frame;
}
- (CGFloat)yc_height
{
    return self.frame.size.height;
}





- (void)setYc_size:(CGSize)yc_size
{
    CGRect frame = self.frame;
    frame.size = yc_size;
    self.frame = frame;
}
- (CGSize)yc_size
{
    return self.frame.size;
}





- (void)setYc_origin:(CGPoint)yc_origin
{
    CGRect frame = self.frame;
    frame.origin = yc_origin;
    self.frame = frame;
}
- (CGPoint)yc_origin
{
    return self.frame.origin;
}


- (void)setYc_top:(CGFloat)yc_top
{
    CGRect frame = self.frame;
    frame.origin.y = yc_top;
    self.frame = frame;
}
- (CGFloat)yc_top
{
    return self.frame.origin.y;
}


- (void)setYc_left:(CGFloat)yc_left
{
    CGRect frame = self.frame;
    frame.origin.x = yc_left;
    self.frame = frame;
}
- (CGFloat)yc_left
{
    return self.frame.origin.x;
}


- (void)setYc_bottom:(CGFloat)yc_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = yc_bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)yc_bottom{
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setYc_right:(CGFloat)yc_right
{
    CGRect frame = self.frame;
    frame.origin.x = yc_right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)yc_right{
    return self.frame.origin.x + self.frame.size.width;
}

@end
