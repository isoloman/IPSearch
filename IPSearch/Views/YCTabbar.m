//
//  YCTabbar.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/12.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCTabbar.h"
#import "UIButton+Ex.h"

@interface YCTabbar ()

@end

@implementation YCTabbar {
    CGFloat _selectedIndex;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews {
    
    UITabBarItem * search = [[UITabBarItem alloc]initWithTitle:@"ip" image:YCImageNamed(@"ip_unselect") selectedImage:YCImageNamed(@"ip_select")];
    search.tag = 100;
    search.image= [[UIImage imageNamed:@"ip_unselect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search.selectedImage= [[UIImage imageNamed:@"ip_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    UITabBarItem * ping = [[UITabBarItem alloc]initWithTitle:@"ping" image:YCImageNamed(@"ping_unselec") selectedImage:YCImageNamed(@"ping_select")];
    ping.tag = 101;
    ping.image= [[UIImage imageNamed:@"ping_unselec"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ping.selectedImage= [[UIImage imageNamed:@"ping_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem * tracert = [[UITabBarItem alloc]initWithTitle:@"tracert" image:YCImageNamed(@"ic_route_un") selectedImage:YCImageNamed(@"ic_route_select")];
    tracert.image= [[UIImage imageNamed:@"ic_route_un"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tracert.selectedImage= [[UIImage imageNamed:@"ic_route_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tracert.tag = 102;
    self.items = @[search,ping,tracert];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:YCColor(37, 155, 36)} forState:UIControlStateSelected];
    if (@available(iOS 10.0, *)) {
        self.unselectedItemTintColor = [UIColor lightGrayColor];
    } else {
        // Fallback on earlier versions
    }
    
    [[UITabBar appearance]setBackgroundImage:[[UIImage alloc]init]];

    [[UITabBar appearance]setBackgroundColor:[YCColorManager tabbarColor]];
    
    self.selectedItem = search;

}

@end
