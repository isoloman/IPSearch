//
//  UIView+ycFrame.h
//  ycDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  这个分类主要用来  快速获得或者添加 控件的尺寸 ....
 */

#import <UIKit/UIKit.h>

@interface UIView (YCFrame)

/// < Shortcut for frame.origin.x.
@property (nonatomic, readwrite, assign) CGFloat yc_left;
/// < Shortcut for frame.origin.y
@property (nonatomic, readwrite, assign) CGFloat yc_top;
/// < Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, readwrite, assign) CGFloat yc_right;
/// < Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, readwrite, assign) CGFloat yc_bottom;

/// < Shortcut for frame.origin.x.
@property (nonatomic, readwrite, assign) CGFloat yc_x;
/// < Shortcut for frame.origin.y
@property (nonatomic, readwrite, assign) CGFloat yc_y;
/// < Shortcut for frame.size.width
@property (nonatomic, readwrite, assign) CGFloat yc_width;
/// < Shortcut for frame.size.height
@property (nonatomic, readwrite, assign) CGFloat yc_height;

/// < Shortcut for center.x
@property (nonatomic, readwrite, assign) CGFloat yc_centerX;
///< Shortcut for center.y
@property (nonatomic, readwrite, assign) CGFloat yc_centerY;

/// < Shortcut for frame.size.
@property (nonatomic, readwrite, assign) CGSize yc_size;
/// < Shortcut for frame.origin.
@property (nonatomic, readwrite, assign) CGPoint yc_origin;




@end
