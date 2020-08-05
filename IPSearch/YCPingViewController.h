//
//  YCPingViewController.h
//  IPSearch
//
//  Created by Gloryyin on 2020/3/14.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YCPingViewDelegate <NSObject>

- (void)yc_netDiagnosisPingDidEnd:(NSInteger)type;

@end

@interface YCPingViewController : UIViewController
@property (nonatomic, weak) id <YCPingViewDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * dormain;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, assign) BOOL isRunning;

- (void)stopNetDiagnosis;
- (void)startNetDiagnosis;
- (void)clearData;
@end

NS_ASSUME_NONNULL_END
