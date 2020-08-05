//
//  ViewController.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/12.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "ViewController.h"
#import "YCTabbar.h"
#import "LDNetGetAddress.h"
#import "YCNetworkRequest.h"
#import "YCProjectManager.h"
#import "YCLocationManager.h"
#import "SVProgressHUD.h"
#import "YCTableViewObj.h"
#import "RealReachability.h"
#import "YCPingViewController.h"
#import "UITextField+Extension.h"
#import "YCHistoryObj.h"
#import "LocalConnection.h"
#import "YCErrorManage.h"
#import "NSDictionary+Extension.h"
#import "IPSearchViewModel.h"
#import "SearchIPHeader.h"

@interface ViewController ()<UITabBarDelegate,UITextFieldDelegate,YCPingViewDelegate,UIScrollViewDelegate,YCHistoryObjProtocol,SearchIPHeaderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titlelbl;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollview;
@property (weak, nonatomic) IBOutlet UILabel *ipLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *IPBGView;
@property (strong, nonatomic) YCTabbar * tabbar;
@property (strong, nonatomic) YCTableViewObj * tableObj;
@property (strong, nonatomic) YCPingViewController * pingVC;
@property (strong, nonatomic) YCPingViewController * tracertVC;
@property (strong, nonatomic) LDNetDiagnoService * netDiagnoService;
@property (strong, nonatomic) NSTimer * netCheckTimer;
@property (strong, nonatomic) YCHistoryObj * historyObj;
@property (strong, nonatomic) SearchIPHeader * header;
@end

@implementation ViewController {
    bool _isSearchedIP , _isPing , _isTracert;
    BOOL _isRunning;
    NSString *_logInfo;
    NSInteger _index;
    BOOL _isChangeClearColor;
    NSString * _netType;
    SSBaseRequest * _requeset;
    dispatch_group_t _group;
    NSString * _rDNSResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self tabbar];
    
    NSLog(@"[YCProjectManager getProxyStatus]+1 =%d",[YCProjectManager getProxyStatus]+1);
}

- (void)viewWillAppear:(BOOL)animated {
//    [self showAddress];
    
}

#pragma mark - privity
- (void)showAddress:(NSArray *)data {
    _netType = [YCProjectManager getNetType];
    NSMutableArray * address = [NSMutableArray new];
    
    [address addObjectsFromArray:data];
    
    [address addObject:_netType];
    if ([YCProjectManager getProxyStatus]) {
        [address addObject:@"vpn"];
    }
    _addressLbl.text = [address componentsJoinedByString:@"."];
    
}

- (void)initData{
    
    _saveBtn.hidden = YES;
    _contentScrollview.contentSize = CGSizeMake(3 * YC_SCREEN_WIDTH, 0);
    _searchBtn.custom_acceptEventInterval = 1.0;
    
    [self netCheckTimer];
    
    self.IPBGView.backgroundColor = [YCColorManager IPBGColor];
    self.botView.backgroundColor = [YCColorManager bgColor];
    self.view.backgroundColor = [YCColorManager bgColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(posted:) name:UIMenuControllerDidHideMenuNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIpInfo) name:@"updateLocation" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(networkChanged:)
//                                                 name:kRealReachabilityChangedNotification
//                                               object:nil];
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    // 2.设置网络状态改变后的处理
    YCWeakSelf(self);
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        [weakself networkChanged:nil];
    }];

    // 3.开始监控
    [manager startMonitoring];
}

- (void)networkChanged:(NSNotification *)notification
{
//    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
//    RealReachability *reachability = (RealReachability *)notification.object;
//    ReachabilityStatus status = [reachability currentReachabilityStatus];
    _netType = [YCProjectManager getNetType];
    if (![_netType isEqualToString:@"无网络"]) {
        [self getIpInfo];
        [[YCLocationManager shareManager] locate];
    }
    else if ([_netType isEqualToString:@"无网络"]) {
        _ipLbl.text = @"";
        [self showAddress:@[]];
    }
}

- (void)posted:(NSNotification*)s{

    if(_searchField.text.length>0) {
        _searchField.text = [YCProjectManager filterUrl:_searchField.text];
        [self changeClearBtnColor];
    }
}

- (void)cheeckNetWork {
    NSString * netType = [YCProjectManager getNetType];
    if (_netType.length&&![_netType isEqualToString:netType]&&![netType isEqualToString:@"无网络"]) {
        [self getIpInfo];
        [[YCLocationManager shareManager] locate];
    }
    else if ([netType isEqualToString:@"无网络"]) {
        _ipLbl.text = @"";
        [self showAddress:@[]];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _searchField.text = [YCProjectManager filterUrl:_searchField.text];
    [self changeClearBtnColor];
    [self.historyObj dismiss];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}


- (void)textFieldDidChange:(NSNotification *)noti  {
    [self changeClearBtnColor];
    
    //清空数据
    _isSearchedIP = NO;
    _isPing = NO;
    _isTracert = NO;
    _saveBtn.hidden = YES;
    
    _rDNSResult = nil;
    _header.alpha = 0;
    [_tableObj.dataSource removeAllObjects];
    [_tableObj.tableView reloadData];
    [_tracertVC clearData];
    [_pingVC clearData];
   
    if (_searchField.text.length == 0) {
        [self.historyObj showHistoryToView:self.view withOrigin: CGRectMake(0, 128+YCAdaptNaviHeight, YC_SCREEN_WIDTH, 0)];
    }else {
        [self.historyObj dismiss];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_searchField.text.length ==0) {
        [self.historyObj showHistoryToView:self.view withOrigin: CGRectMake(0, 128+YCAdaptNaviHeight, YC_SCREEN_WIDTH, 0)];
    }
    
}

- (void)changeClearBtnColor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchField setClearColor:[UIColor darkGrayColor]];
        _isChangeClearColor = YES;
    });
}

#pragma mark - YCHistoryObjProtocol

- (void)yc_historyObjDidmiss {
    
}

- (void)yc_historyTableObjDidSelectRow:(NSString *)text{
    [self.historyObj dismiss];
    _searchField.text = text;
    [self changeClearBtnColor];
}

#pragma mark - # SearchIPHeaderDelegate
- (void)yc_reverseDidSelect {
    NSString * reverseStr = [@"https://ipchaxun.com/" stringByAppendingString:self.searchField.text];
    [IPSearchViewModel handleUrlAddress:reverseStr];
}

- (void)yc_locationDidSelect {
    NSString * ip = [IPSearchViewModel changeIPLastComponent:self.searchField.text];
    NSString * dingweiStr = [@"https://dingweilishi.com/" stringByAppendingString:ip];
    [IPSearchViewModel handleUrlAddress:dingweiStr];
}

- (void)yc_pangzhanDidSelect{
    NSString * ip = [IPSearchViewModel changeIPLastComponent:self.searchField.text];
    NSString * pangzhanStr = [@"https://chapangzhan.com/" stringByAppendingString:ip];
    [IPSearchViewModel handleUrlAddress:pangzhanStr];
}

#pragma mark - btnAction
- (IBAction)searchAction:(id)sender {
    _searchField.text = [YCProjectManager filterUrl:_searchField.text];
    [_searchField endEditing:YES];
    [YCProjectManager addSearchRecordToHistory:_searchField.text];
    
    if (![YCProjectManager checkAvailableUrlAddress:_searchField.text]&&![YCProjectManager isValidatIP:_searchField.text]) {
        [SVProgressHUD showInfoWithStatus:@"非法IP或地址"];
        return;
    }
    
    if (_index == 0) {
        _tableObj.dormain = _searchField.text;
        ///链接直接跳转
        if ([YCProjectManager checkAvailableUrlAddress:_searchField.text]) {
            [IPSearchViewModel handleAvailableUrlAddress:_searchField.text];
        }
        else {
            _isSearchedIP = NO;
            _saveBtn.hidden = YES;
//            if ([[YCProjectManager getNetType] isEqualToString:@"无网络"]) {
//                [SVProgressHUD showInfoWithStatus:@"无网络连接,请检查您的网络后重试"];
//                return;
//            }
            [self beginSearch:_searchField.text];
        }
    }
    else if (_index == 1) {
        self.netDiagnoService.type = 0;
        _isPing = NO;
        _saveBtn.hidden = YES;
        [self startNetDiagnosis];
    }
    else if (_index == 2) {
        self.netDiagnoService.type = 1;
        _isTracert = NO;
        _saveBtn.hidden = YES;
        [self startNetDiagnosis];
    }
}
- (IBAction)saveAction:(id)sender {
    UIImage * image;
    image = [YCProjectManager makeImageWithView:self.view withSize:[UIScreen mainScreen].bounds.size];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (IBAction)tapBotIP:(id)sender {
    if (_searchField.text.length == 0) {
        _searchField.text = _ipLbl.text;
        [self changeClearBtnColor];
    }
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [SVProgressHUD showInfoWithStatus:msg];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [SVProgressHUD dismiss];
    _index = item.tag - 100;
    if (item.tag == 100) {
        _titlelbl.text = @"iP查询";
        [_searchBtn setTitle:@"查询" forState:UIControlStateNormal];
        _saveBtn.hidden = !_isSearchedIP;
        _contentScrollview.contentOffset = CGPointMake(0, 0);
        _searchField.userInteractionEnabled = YES;
        if (_tableObj.dataSource.count) {
            _searchField.text = _tableObj.dormain;
        }
    }
    else if (item.tag == 101) {
        _titlelbl.text = @"Ping";
        [_searchBtn setTitle:_pingVC.isRunning?@"stop":@"ping" forState:UIControlStateNormal];
        _saveBtn.hidden = !_isPing;
        _contentScrollview.contentOffset = CGPointMake(YC_SCREEN_WIDTH, 0);
        _searchField.userInteractionEnabled = !_pingVC.isRunning;
        if (_pingVC.isRunning||(_pingVC.textView.text.length)) {
            _searchField.text = _pingVC.dormain;
        }
    }
    else if (item.tag == 102){
        _titlelbl.text = @"Tracert";
        [_searchBtn setTitle:_tracertVC.isRunning?@"stop":@"tracert" forState:UIControlStateNormal];
        _saveBtn.hidden = !_isTracert;
        _contentScrollview.contentOffset = CGPointMake(2 * YC_SCREEN_WIDTH, 0);
        _searchField.userInteractionEnabled = !_tracertVC.isRunning;
        if (_tracertVC.isRunning||(_tracertVC.textView.text.length)) {
            _searchField.text = _tracertVC.dormain;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX/YC_SCREEN_WIDTH;
    _index = page;
    UITabBarItem * item = _tabbar.items[_index];
    _tabbar.selectedItem = item;
    [self tabBar:_tabbar didSelectItem:item];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchField endEditing:YES];
}
#pragma mark - LDNetDiagnoServiceDelegate

- (void)stopNetDiagnosis {
    [_searchBtn setTitle:_index ==1?@"ping":_index==2?@"tracert":@"查询" forState:UIControlStateNormal];
}

- (void)startNetDiagnosis
{
    [self.searchField resignFirstResponder];
    
    YCPingViewController * vc;
    if (_index == 1) {
        vc = self.pingVC;
    }
    else if (_index == 2) {
        vc = self.tracertVC;
    }
    vc.dormain = _searchField.text;
    _searchField.userInteractionEnabled = NO;
    
    if (!_isRunning) {
        NSLog(@"run");
        _isRunning = YES;
        [_searchBtn setTitle:@"stop" forState:UIControlStateNormal];
        [vc startNetDiagnosis];
    } else {
        _isRunning = NO;
        [self stopNetDiagnosis];
        [vc startNetDiagnosis];
        if (vc.isRunning) {
            [_searchBtn setTitle:@"stop" forState:UIControlStateNormal];
        }
        NSLog(@"stop");
    }
}

- (void)yc_netDiagnosisPingDidEnd:(NSInteger)type
{
    
    //可以保存到文件，也可以通过邮件发送回来
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == 1) {
            if (_index == 2) {
                [_searchBtn setTitle:@"tracert" forState:UIControlStateNormal];
                _searchField.userInteractionEnabled = YES;
            }
            _isTracert = YES;
        }
        else if (type == 0) {
            if (_index == 1) {
                [_searchBtn setTitle:@"ping" forState:UIControlStateNormal];
                _searchField.userInteractionEnabled = YES;
            }
            _isPing = YES;
        }
        
        _isRunning = NO;
        
        [self adjustSaveBtn];
    });
}


- (void)adjustSaveBtn {
    if ((_index == 0 && _isSearchedIP)||(_index == 1 && _isPing)||(_index == 2 && _isTracert)) {
        _saveBtn.hidden = NO;
    }
    else {
        _saveBtn.hidden = YES;
    }
}

//TODO:begin search
- (void)beginSearch:(NSString *)ip {
    
    _header.alpha = 1;
    
    if (!_group) {
        _group = dispatch_group_create();
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(_group);
    [self searchIP:ip];
    
    dispatch_group_enter(_group);
    [self searchrDNSInfo:ip];
    
    dispatch_group_notify(_group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_rDNSResult) {
                [self.tableObj.dataSource insertObject:@{@"name":@"rDNS",@"addr":_rDNSResult} atIndex:1];
            }
            [self.tableObj.tableView reloadData];
        });
        
    });
}

#pragma mark - 网络请求

- (void)getIpInfo {
    ///退出到后台重新进入会变回去，所以将就在这里添加
    [self changeClearBtnColor];
    
//    if (_requeset&&_requeset.requestTask.state == NSURLSessionTaskStateRunning) {
//        return;
//    }
    
    _requeset =
    [YCNetworkRequest getCurrentIPInfoWithComplete:^(NetWorkResponseType type, id  _Nonnull object) {
        
        if ([object isKindOfClass:[NSDictionary class]]&&[[object valueForKey:@"ret"] isEqualToString:@"ok"]) {
            _ipLbl.text = [object valueForKey:@"ip"];
            
            NSArray * data = [object valueForKey:@"data"];
            NSMutableArray * sub = [NSMutableArray new];
            
            for (int i = 0; i < 5; i++) {
                NSString * str = data[i];
                if (![str containsString:@"中国"]&&str.length && i != 3) {
                    [sub addObject:str];
                }
                else if (i == 3 &&str.length) {
                    [sub addObject:str];
                }
            }
            
            [self showAddress:sub];
        }
        else {
//            [SVProgressHUD showInfoWithStatus:@"网络请求失败"];
            _ipLbl.text = @"";
            [self showAddress:@[]];
            
            if ([object isKindOfClass:[NSError class]]) {
                NSError * err = object;
                if (err.code == -1009) {
                    return ;
                }
                [SVProgressHUD showInfoWithStatus:[YCErrorManage getErrorMsgByCode:err.code]];
                return ;
            }
           
        }
    }];
}

//TODO:查询IP
- (void)searchIP:(NSString *)ip {
    if (ip.length > 0) {
        [SVProgressHUD show];
        [YCNetworkRequest searchIPInfo:ip withComplete:^(NetWorkResponseType type, id  _Nonnull object) {
            dispatch_group_leave(_group);
            [SVProgressHUD dismiss];
            if ([object isKindOfClass:[NSError class]]) {
                NSError * err = object;
                [SVProgressHUD showInfoWithStatus:[YCErrorManage getErrorMsgByCode:err.code]];
                return ;
            }
            _isSearchedIP = YES;
            if ([[object valueForKey:@"msg"] isEqualToString:@"ok"]) {
                NSArray * source = [object valueForKey:@"result"];
                NSMutableArray * data = [IPSearchViewModel handleSearchIPResult:source withIP:_searchField.text];
                self.tableObj.dataSource = data;
                _isSearchedIP = YES;
                _saveBtn.hidden = NO;
            }
            else {
                if ([[object valueForKey:@"status"] intValue] == 3) {
                    [SVProgressHUD showInfoWithStatus:@"非法IP或地址"];
                }
                else
                [SVProgressHUD showInfoWithStatus:[object valueForKey:@"msg"]];
            }
        }];
    }
}

- (void)searchrDNSInfo:(NSString *)ip {
    [YCNetworkRequest searchrDNSInfo:(NSString *)ip withComplete:^(NetWorkResponseType type, id  _Nonnull object) {
        dispatch_group_leave(_group);
        if ([object isKindOfClass:[NSDictionary class]]&&[[object valueForKey:@"status"] boolValue]) {
            _rDNSResult = [[object valueForKey:@"data"] valueForKey:@"result"];
        }
    }];
}

#pragma mark - property
- (YCTabbar *)tabbar {
    if (!_tabbar) {
        _tabbar = [YCTabbar new];
        _tabbar.delegate = self;
        [self.botView addSubview:_tabbar];
        
        [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_botView);
            make.height.mas_equalTo(49);
        }];
    }
    
    return _tabbar;
}

- (YCTableViewObj *)tableObj {
    if (!_tableObj) {
        _tableObj = [YCTableViewObj new];
        [self.contentScrollview addSubview:_tableObj.tableView];
        _tableObj.tableView.frame = CGRectMake(0, 0, YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT - 148 -123 -(YCAdaptNaviHeight+YCAdaptTabHeight));
        
        __weak typeof(self) weak = self;
        _tableObj.didSelectedBlock = ^(NSString * _Nonnull content) {
            NSString * ip = [IPSearchViewModel changeIPLastComponent:weak.searchField.text];
            NSString * rDNSStr = [@"https://rdnsdb.com/" stringByAppendingString:ip];
            [IPSearchViewModel handleUrlAddress:rDNSStr];
        };
        
        _header = [[SearchIPHeader alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, kSearchIPHeaderHeight)];
        _header.delegate = self;
        _tableObj.tableView.tableHeaderView = _header;
        
    }
    
    return _tableObj;
}

- (YCPingViewController *)pingVC {
    if (!_pingVC) {
        _pingVC = [YCPingViewController new];
        _pingVC.dormain = _searchField.text;
        _pingVC.delegate = self;
        _pingVC.type = 0;
        [self addChildViewController: _pingVC];
        [self.contentScrollview addSubview:_pingVC.view];
        _pingVC.view.frame = CGRectMake(YC_SCREEN_WIDTH, 0, YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT - 148 -123 -(YCAdaptNaviHeight+YCAdaptTabHeight));
    }
    
    return _pingVC;
}


- (YCPingViewController *)tracertVC {
    if (!_tracertVC) {
        _tracertVC = [YCPingViewController new];
        _tracertVC.dormain = _searchField.text;
        _tracertVC.delegate = self;
        _tracertVC.type = 1;
        [self addChildViewController: _tracertVC];
        [self.contentScrollview addSubview:_tracertVC.view];
        _tracertVC.view.frame = CGRectMake(2*YC_SCREEN_WIDTH, 0, YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT - 148 -123 -(YCAdaptNaviHeight+YCAdaptTabHeight));
    }
    
    return _tracertVC;
}
- (YCHistoryObj *)historyObj {
    if (!_historyObj) {
        _historyObj = [YCHistoryObj new];
        _historyObj.delegate = self;
    }
    
    return _historyObj;
}

- (NSTimer *)netCheckTimer {
    if (!_netCheckTimer) {
        _netCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(cheeckNetWork) userInfo:nil repeats:YES];
        [_netCheckTimer fire];
    }
    
    return _netCheckTimer;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_netCheckTimer invalidate];
    _netCheckTimer = nil;
}

@end
