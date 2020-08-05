//
//  YCPingViewController.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/14.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCPingViewController.h"
#import "LDNetGetAddress.h"

@interface YCPingViewController ()<LDNetDiagnoServiceDelegate>
@property (strong, nonatomic) LDNetDiagnoService * netDiagnoService;
@end

@implementation YCPingViewController {
    
    NSString *_logInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textView];
    self.view.backgroundColor = [YCColorManager bgColor];
}

- (void)clearData {
    if (!_isRunning) {
        _logInfo = @"";
        _textView.text = @"";
    }
    
}

#pragma mark - LDNetDiagnoServiceDelegate

- (void)delayMethod
{
//    [_searchBtn setBackgroundColor:[UIColor lightGrayColor]];
//    [_searchBtn setUserInteractionEnabled:TRUE];
}

- (void)stopNetDiagnosis {
    _isRunning = NO;
    [_netDiagnoService stopNetDialogsis];
}

- (void)startNetDiagnosis
{
    
    if (!_isRunning) {
        _logInfo = @"";
        _isRunning = !_isRunning;
        [_netDiagnoService startNetDiagnosis];
    } else {
        [self stopNetDiagnosis];
    }
}

- (void)netDiagnosisDidStarted
{
    NSLog(@"开始诊断～～～");
}

- (void)netDiagnosisStepInfo:(NSString *)stepInfo
{
    NSLog(@"%@", stepInfo);
    _logInfo = [_logInfo stringByAppendingString:stepInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = _logInfo;
        
        CGPoint bottomOffset = CGPointMake(0, _textView.contentSize.height - _textView.bounds.size.height);
        if (bottomOffset.y > 0) {
            [_textView setContentOffset:bottomOffset animated:YES];
        }
        
    });
}


- (void)netDiagnosisDidEnd:(NSString *)allLogInfo;
{
    NSLog(@"logInfo>>>>>\n%@", allLogInfo);
    _isRunning = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(yc_netDiagnosisPingDidEnd:)]) {
        [_delegate yc_netDiagnosisPingDidEnd:_type];
    }
}

- (void)setType:(NSInteger)type {
    _type = type;
    self.netDiagnoService.type = type;
    UITextField * button;
}

- (void)setDormain:(NSString *)dormain {
    _dormain = dormain;
    self.netDiagnoService.dormain = dormain;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:11.0f];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.scrollEnabled = YES;
        _textView.editable = NO;
        _textView.backgroundColor = [YCColorManager bgColor];
        _textView.textColor = YCColor(0, 0, 0);
        [self.view addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    return  _textView;
}

- (LDNetDiagnoService *)netDiagnoService {
    if (!_netDiagnoService) {
        _netDiagnoService = [[LDNetDiagnoService alloc] initWithAppCode:@"ipchaxun"
                                                                appName:@"IP查询"
                                                             appVersion:@"1.0.0"
                                                                 userID:@"com.manyou.ipchaxun"
                                                               deviceID:nil
                                                                dormain:_dormain
                                                            carrierName:nil
                                                         ISOCountryCode:nil
                                                      MobileCountryCode:nil
                                                          MobileNetCode:nil];
        _netDiagnoService.delegate = self;
        _isRunning = NO;
    }
    
    return _netDiagnoService;
}

@end
