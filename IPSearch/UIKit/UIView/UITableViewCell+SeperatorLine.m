//
//  UITableViewCell+SeperatorLine.m
//  DisplayExpression
//
//  Created by administrator on 2017/3/6.
//  Copyright © 2017年 star. All rights reserved.
//

#import "UITableViewCell+SeperatorLine.h"
static NSInteger defalutTag = 20170101;
static NSInteger topTag = 20170102;

@implementation UITableViewCell (SeperatorLine)

- (void)hiddenSepetarorLine:(BOOL)hidden{
    UIView * seperator = [self viewWithTag:defalutTag];
    if (seperator) {
        seperator.hidden = hidden;
    }
}

- (BOOL)hasAddSepetatorLine{
    if ([self viewWithTag:defalutTag]) {
        return YES;
    }
    
    return NO;
}

- (void)addSepetarorLineWithEdge:(YCLineEdge)edge withColor:(UIColor *)color{
    if (![self viewWithTag:defalutTag]) {
        
        UIView * view = [UIView new];
        view.backgroundColor = color;
        view.tag = defalutTag;
        [self.contentView addSubview:view];
       
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:edge.left]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-edge.right]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        
        NSLayoutConstraint * layout = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:.5];
        layout.identifier = @"height";
        [self addConstraint:layout];
    }
    else{
        UIView * view = [self viewWithTag:defalutTag];
        view.backgroundColor = color;
        for (NSLayoutConstraint * layout in self.constraints) {
            if ([layout.identifier isEqualToString: @"height"]){
                layout.constant = .5;
            }
        }
    }
}

- (void)addSepetarorLineWithEdge:(YCLineEdge)edge withColor:(UIColor *)color position:(YCLinePosition)position{
    
    if (position == YCLinePositionTop && [self viewWithTag:topTag] ) {
        return;
    }
    
    if (position == YCLinePositionBottom && [self viewWithTag:defalutTag] ) {
        return;
    }
    
        
    UIView * view = [UIView new];
    view.backgroundColor = color;
    
    [self.contentView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:edge.left]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-edge.right]];
    
    if (position == YCLinePositionBottom) {
        view.tag = defalutTag;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    else if (position == YCLinePositionTop){
        view.tag = topTag;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    }
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:.5]];
    

}
    
- (void)addSepetarorLineWithInsetBoth:(CGFloat)inset withColor:(UIColor *)color{
    [self addSepetarorLineWithInsetBoth:inset withColor:color height:.5];
}

- (void)addSepetarorLineWithInsetBoth:(CGFloat)inset withColor:(UIColor *)color height:(CGFloat)height{
    if (![self viewWithTag:defalutTag]) {
        
        UIView * view = [UIView new];
        view.backgroundColor = color;
        view.tag = defalutTag;
        [self.contentView addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:inset]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-inset]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
    }
    else{
        UIView * view = [self viewWithTag:defalutTag];
        view.backgroundColor = color;
    }
    
}

@end
