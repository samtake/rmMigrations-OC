//
//  NotifycationController.m
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/22.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "NotifycationController.h"
#import "TableViewController.h"

@interface NotifycationController (){
    UIButton *btn0;
    UIButton *btn1;
}

@end

@implementation NotifycationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}
-(void)setupUI{
    btn0 = [UIButton new];
    [btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn0.backgroundColor = [UIColor yellowColor];
    [btn0 addTarget:self action:@selector(tableView) forControlEvents:UIControlEventTouchUpInside];
    [btn0 setTitle:@"tableView" forState:UIControlStateNormal];
    
    
    UIView *contentView = self.view;
    [self.view sd_addSubviews:@[btn0]];
    
    btn0.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 200)
    .heightIs(50);
}

-(void)tableView{
    [self.navigationController pushViewController:[TableViewController new] animated:true];
}

@end
