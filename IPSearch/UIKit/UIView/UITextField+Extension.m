//
//  UITextField+Extension.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/14.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "UITextField+Extension.h"


@implementation UITextField (Extension)

- (void)setClearColor:(UIColor *)color {
    UIButton *btnClear = [self buttonClear];
    UIImage *imageNormal = [btnClear imageForState:UIControlStateNormal];
    UIGraphicsBeginImageContextWithOptions(imageNormal.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect rect = (CGRect){ CGPointZero, imageNormal.size };
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [imageNormal drawInRect:rect];

    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);

    UIImage *imageTinted  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [btnClear setImage:imageTinted forState:UIControlStateNormal];
}

-(UIButton *) buttonClear
{
    for(UIView *v in self.subviews)
    {
        if([v isKindOfClass:[UIButton class]])
        {
            UIButton *buttonClear = (UIButton *) v;
            return buttonClear;
        }
    }
    return nil;
}

@end
