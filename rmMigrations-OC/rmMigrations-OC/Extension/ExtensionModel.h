//
//  ExtensionModel.h
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/24.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtensionModel : RLMObject
@property (nonatomic, strong) NSString *tickID;

@property (nonatomic, assign) NSInteger count;
@end

NS_ASSUME_NONNULL_END
