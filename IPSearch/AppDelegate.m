//
//  AppDelegate.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/12.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "AppDelegate.h"
#import "YCLocationManager.h"
#import "YCProjectManager.h"
#import "SVProgressHUD.h"
#import "RealReachability.h"
#import "IQKeyboardManager.h"
#import <Bugly/Bugly.h>
#import <UMCommon/UMCommon.h>

#define BuglyID @"cf63dd54ac"
#define UMAppkey @"5e781c31570df3f02800022b"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    NSString * _umchannel;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    BuglyConfig * bugly_config = [[BuglyConfig alloc] init];
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    #ifdef DEBUG
        bugly_config.channel = [@"DEBUG_" stringByAppendingString:version];
        bugly_config.debugMode = YES;
        _umchannel = @"debug";
    #else
        bugly_config.channel = [@"release_" stringByAppendingString:version];
        _umchannel = @"App Store";
    #endif
        
    [Bugly startWithAppId:BuglyID config:bugly_config];
    
    [UMConfigure initWithAppkey:UMAppkey channel:_umchannel];
    
    [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleDark];
    [[YCLocationManager shareManager] locate];
    [[SVProgressHUD appearance] setMaximumDismissTimeInterval:1.5];
    [GLobalRealReachability startNotifier];
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    return YES;
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[YCLocationManager shareManager] locate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
}

@end
