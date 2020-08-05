//
//  YCIPInfoViewHeaderView.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/13.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCIPInfoViewHeaderView.h"

@interface YCIPInfoViewHeaderView ()
@property (nonatomic, strong) UILabel * text;
@end

@implementation YCIPInfoViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self _initSubView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)_initSubView {
    _text = [UILabel new];
    _text.font = YCSystemFont(13);
    _text.textColor = YCColor(26, 118, 210);
    [self.contentView addSubview:_text];
    
    [_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.equalTo(self.contentView).with.offset(4);
    }];
}

- (void)setTitle:(NSString *)titleStr {
    _text.text = titleStr;
}

- (void)setTitleColor:(UIColor *)color {
    _text.textColor = color;
}

@end
