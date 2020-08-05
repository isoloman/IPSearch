//
//  YCHistoryObj.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/15.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCHistoryObj.h"
#import "YCProjectManager.h"
#import "YCIPInfoViewHeaderView.h"
#import "UITableViewCell+SeperatorLine.h"

@implementation YCHistoryObj

- (void)reloadData {
    _dataSource = [YCProjectManager getSearchHistory];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor blackColor];
        [cell addSepetarorLineWithEdge:YCLineEdgeMake(16, 16) withColor:[UIColor lightGrayColor]];
    }
    
    cell.contentView.backgroundColor = [YCColorManager bgColor];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(yc_historyTableObjDidSelectRow:)]) {
        [_delegate yc_historyTableObjDidSelectRow:_dataSource[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YCIPInfoViewHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YCIPInfoViewHeaderView"];
//    header.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [header setTitleColor:[UIColor blackColor]];
    [header setTitle:@"历史记录"];
    return header;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [YCProjectManager removeSearchRecordFormHistory:indexPath.row];
    [self reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)showHistoryToView:(UIView *)view withOrigin:(CGRect)rect{
    _dataSource = [YCProjectManager getSearchHistory];
    if (_dataSource.count ==0) {
        return;
    }
    self.tableView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
    [view addSubview:_tableView];
    
    [UIView animateWithDuration:.2 animations:^{
        
        if (YC_SCREEN_HEIGHT > 667) {
            _tableView.yc_height = 6 * 44;
        }
        else if (YC_SCREEN_HEIGHT > 568){
            _tableView.yc_height = 5 * 44;
        }
        else {
            _tableView.yc_height = 3 * 44;
        }
    }];
    [self reloadData];
}

- (void)dismiss{
    [UIView animateWithDuration:.2 animations:^{
        _tableView.yc_height = 0;
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        // set delegate and dataSource
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [YCColorManager bgColor];
        _tableView.rowHeight = 44;
//        _tableView.layer.borderColor = [UIColor blackColor].CGColor;
//        _tableView.layer.borderWidth = .5;
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
