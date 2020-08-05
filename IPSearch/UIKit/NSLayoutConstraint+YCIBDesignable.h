//
//  NSLayoutConstraint+YCIBDesignable.h
//  shiku_im
//
//  Created by apple on 2019/8/23.
//  Copyright © 2019 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (YCIBDesignable)
@property(nonatomic, assign) IBInspectable BOOL adapterScreen;
@property(nonatomic, assign) IBInspectable BOOL is_adapterIPhoneX;
@property(nonatomic, assign) IBInspectable CGFloat adapterHeight;
@end

NS_ASSUME_NONNULL_END
