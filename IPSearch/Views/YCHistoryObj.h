//
//  YCHistoryObj.h
//  IPSearch
//
//  Created by Gloryyin on 2020/3/15.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YCHistoryObjProtocol<NSObject>
- (void)yc_historyTableObjDidSelectRow:(NSString *)text;
- (void)yc_historyObjDidmiss;
@end

@interface YCHistoryObj : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, weak) id<YCHistoryObjProtocol>delegate;

- (void)showHistoryToView:(UIView *)view withOrigin:(CGRect)rect;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
