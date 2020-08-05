//
//  YCTableViewObj.h
//  IPSearch
//
//  Created by Gloryyin on 2020/3/13.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTableViewObj : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, copy) NSString * dormain;

@property (nonatomic, copy) void(^didSelectedBlock)(NSString * content);
@end

NS_ASSUME_NONNULL_END
