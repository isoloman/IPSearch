//
//  YCTableViewObj.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/13.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCTableViewObj.h"
#import "YCIPInfoViewHeaderView.h"

@implementation YCTableViewObj

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.numberOfLines = 0;
    cell.contentView.backgroundColor = [YCColorManager bgColor];
    cell.textLabel.text = [_dataSource[indexPath.section] valueForKey:@"addr"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YCIPInfoViewHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YCIPInfoViewHeaderView"];
    [header setTitle:[_dataSource[section] valueForKey:@"name"]];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_dataSource[indexPath.section] valueForKey:@"name"] isEqualToString:@"rDNS"]) {
        return 60;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectedBlock&&[[_dataSource[indexPath.section] valueForKey:@"name"] isEqualToString:@"rDNS"]) {
        _didSelectedBlock([_dataSource[indexPath.section] valueForKey:@"addr"]);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // set delegate and dataSource
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [YCColorManager bgColor];
        [_tableView registerClass:[YCIPInfoViewHeaderView class] forHeaderFooterViewReuseIdentifier:@"YCIPInfoViewHeaderView"];
        
        if (@available(iOS 11.0, *)) {
            /// CoderMikeHe: 适配 iPhone X + iOS 11，
            MHAdjustsScrollViewInsets_Never(_tableView);
            /// iOS 11上发生tableView顶部有留白，原因是代码中只实现了heightForHeaderInSection方法，而没有实现viewForHeaderInSection方法。那样写是不规范的，只实现高度，而没有实现view，但代码这样写在iOS 11之前是没有问题的，iOS 11之后应该是由于开启了估算行高机制引起了bug。
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        
    }
    
    return _tableView;
}

@end
