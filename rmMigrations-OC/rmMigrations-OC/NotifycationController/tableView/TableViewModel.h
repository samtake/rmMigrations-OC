//
//  TableViewModel.h
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/23.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewModel : RLMObject
@property NSString *title;
@property NSDate   *date;
@end

NS_ASSUME_NONNULL_END
