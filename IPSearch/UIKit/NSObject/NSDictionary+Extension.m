//
//  NSDictionary+Extension.m
//  IPSearch
//
//  Created by Gloryyin on 2020/8/4.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)
-(NSString *)getNoNullValue:(NSString *)key {
    NSString * value = [self valueForKey:key];
    if (value.length==0||!value||[value containsString:@"null"]) {
        return @"";
    }
    
    return value;
}
@end
