//
//  IPSearchViewModel.h
//  IPSearch
//
//  Created by Gloryyin on 2020/8/4.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPSearchViewModel : NSObject
+ (void)handleAvailableUrlAddress:(NSString *)ip;
+ (void)handleUrlAddress:(NSString *)url ;
+ (NSString *)changeIPLastComponent:(NSString *)ip;
+ (NSMutableArray *)handleSearchIPResult:(NSArray *)source withIP:(NSString *)ip;
@end

NS_ASSUME_NONNULL_END
