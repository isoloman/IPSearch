//
//  YCErrorManage.h
//  IPSearch
//
//  Created by Gloryyin on 2020/3/24.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCErrorManage : NSObject
+ (NSString *)getErrorMsgByCode:(NSInteger)code;
+ (NSString *)getResponseMsgByStatusCode:(NSInteger)code;
@end

NS_ASSUME_NONNULL_END
