//
//  ExtensionController.m
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/22.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "ExtensionController.h"
#import "ExtensionModel.h"

@interface ExtensionController()
@property (nonatomic, strong) UIButton *button;
@property(nonatomic, strong) UILabel *label;
@property (nonatomic, strong) ExtensionModel *tick;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@end

@interface ExtensionController ()

@end

@implementation ExtensionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tick = [ExtensionModel allObjects].firstObject;
    if (!self.tick) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            self.tick = [ExtensionModel createInDefaultRealmWithValue:@[@"", @0]];
        }];
    }
    self.notificationToken = [self.tick.realm addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        // Occasionally, respond immediately to the notification by triggering a new notification.
        if (self.tick.count % 13 == 0) {
            [self buttonClick];
        }
        [self updateLabel];
    }];
    
    
    [self setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel new];
    label.textColor=[UIColor blackColor];
    label.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label];
    label.textAlignment=NSTextAlignmentCenter;
    self.label=label;
    
    UIButton  *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor=[UIColor  yellowColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"点击我->count值 +1" forState:UIControlStateNormal];
    [self.view addSubview:button];
    self.button=button;
    
    
    
    
    UIView *contentView = self.view;
    [self.view sd_addSubviews:@[label,button]];
    
    label.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 200)
    .heightIs(50);
    
    button.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(label, 30)
    .heightIs(50);
    
    
    [self updateLabel];
}

- (void)updateLabel {
    self.label.text=[NSString stringWithFormat:@"count的值：%@",@(self.tick.count).stringValue];
}

- (void)buttonClick {
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        self.tick.count++;
    }];
}
@end
