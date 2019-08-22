//
//  Dog.h
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/22.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dog : RLMObject
////v0
//@property NSString *name;
//@property NSInteger age;
//v1
@property NSString *oneWorld;
@property NSString *name;
@property NSInteger age;
@end

NS_ASSUME_NONNULL_END
