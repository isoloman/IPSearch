//
//  SearchIPHeader.h
//  IPSearch
//
//  Created by Gloryyin on 2020/8/4.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat kSearchIPHeaderHeight = 30;

@protocol SearchIPHeaderDelegate <NSObject>

- (void)yc_reverseDidSelect;
- (void)yc_locationDidSelect;
- (void)yc_pangzhanDidSelect;

@end

@interface SearchIPHeader : UIView
@property (nonatomic, weak) id <SearchIPHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
