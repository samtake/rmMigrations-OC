//
//  Person.h
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/22.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "RLMObject.h"
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN
RLM_ARRAY_TYPE(Dog) //RLM_ARRAY_TYPE宏创建了一个协议，从而允许RLMArray<Dog> *dogs语法的使用
@interface Person : RLMObject
@property NSString      *name;
@property RLMArray <Dog> *dogs;
@end

NS_ASSUME_NONNULL_END
