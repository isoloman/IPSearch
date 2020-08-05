//
//  SearchIPHeader.m
//  IPSearch
//
//  Created by Gloryyin on 2020/8/4.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "SearchIPHeader.h"

@interface SearchIPHeader ()
@property (nonatomic, strong) UIButton * reverseBtn;
@property (nonatomic, strong) UIButton * locationBtn;
@property (nonatomic, strong) UIButton * pangzhanBtn;
@end

@implementation SearchIPHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubview];
    }
    return self;
}

- (void)reverseAction {
    if (_delegate && [_delegate respondsToSelector:@selector(yc_reverseDidSelect)]) {
        [_delegate yc_reverseDidSelect];
    }
}

- (void)locationAction {
    if (_delegate && [_delegate respondsToSelector:@selector(yc_locationDidSelect)]) {
        [_delegate yc_locationDidSelect];
    }
}

- (void)pangzhanAction {
    if (_delegate && [_delegate respondsToSelector:@selector(yc_pangzhanDidSelect)]) {
        [_delegate yc_pangzhanDidSelect];
    }
}

- (void)configSubview {
    CGFloat width = (YC_SCREEN_WIDTH - 16 * 3)/3.0;
    
    _reverseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reverseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _reverseBtn.layer.cornerRadius =kSearchIPHeaderHeight/2.0;
    [_reverseBtn setBackgroundColor:YCColor(37, 155, 36)];
    [_reverseBtn setTitle:@"iP反查网站" forState:UIControlStateNormal];
    [_reverseBtn addTarget:self action:@selector(reverseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reverseBtn];
    _reverseBtn.frame = CGRectMake(16, 0, width, kSearchIPHeaderHeight);
    
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _locationBtn.layer.cornerRadius =kSearchIPHeaderHeight/2.0;
    [_locationBtn setBackgroundColor:YCColor(37, 155, 36)];
    [_locationBtn setTitle:@"定位历史" forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationBtn];
    _locationBtn.frame = CGRectMake(16 + width + 8, 0, width, kSearchIPHeaderHeight);
    
    _pangzhanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _pangzhanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _pangzhanBtn.layer.cornerRadius =kSearchIPHeaderHeight/2.0;
    [_pangzhanBtn setBackgroundColor:YCColor(37, 155, 36)];
    [_pangzhanBtn setTitle:@"旁站查询" forState:UIControlStateNormal];
    [_pangzhanBtn addTarget:self action:@selector(pangzhanAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pangzhanBtn];
    _pangzhanBtn.frame = CGRectMake(16 + width*2 + 8*2, 0, width, kSearchIPHeaderHeight);
}

@end
