//
//  Dog.m
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/22.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "Dog.h"

@implementation Dog
//// 主键
//+ (NSString *)primaryKey {
//    return @"ID";
//}

//设置属性默认值
+ (NSDictionary *)defaultPropertyValues{
    return @{@"name":@"big dog" };
}

////设置忽略属性,即不存到realm数据库中
//+ (NSArray<NSString *> *)ignoredProperties {
//    return @[@"ID"];
//}

//一般来说,属性为nil的话realm会抛出异常,但是如果实现了这个方法的话,就只有name为nil会抛出异常,也就是说现在cover属性可以为空了
+ (NSArray *)requiredProperties {
    return @[@"name"];
}

////设置索引,可以加快检索的速度
//+ (NSArray *)indexedProperties {
//    return @[@"ID"];
//}
@end
