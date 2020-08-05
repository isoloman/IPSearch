//
//  UITableViewCell+SeperatorLine.h
//  DisplayExpression
//
//  Created by administrator on 2017/3/6.
//  Copyright © 2017年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct YCLineEdge {
    CGFloat  left, right;  
} YCLineEdge;

typedef NS_ENUM(NSInteger,YCLinePosition) {
    YCLinePositionTop = 0 ,
    YCLinePositionBottom
};

UIKIT_STATIC_INLINE YCLineEdge YCLineEdgeMake(CGFloat left , CGFloat right) {
    YCLineEdge edge = {left, right};
    return edge;
}

@interface UITableViewCell (SeperatorLine)

- (void)addSepetarorLineWithEdge:(YCLineEdge)edge withColor:(UIColor *)color;
- (void)addSepetarorLineWithInsetBoth:(CGFloat)inset withColor:(UIColor *)color;
- (void)addSepetarorLineWithInsetBoth:(CGFloat)inset withColor:(UIColor *)color height:(CGFloat)height;
- (void)hiddenSepetarorLine:(BOOL)hidden;


- (void)addSepetarorLineWithEdge:(YCLineEdge)edge withColor:(UIColor *)color position:(YCLinePosition)position;

- (BOOL)hasAddSepetatorLine;

@end
