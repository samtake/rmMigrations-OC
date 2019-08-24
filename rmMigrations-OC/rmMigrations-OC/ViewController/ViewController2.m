//
//  ViewController2.m
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/22.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "ViewController2.h"
#import "BacklinkController.h"
#import "EncryptionController.h"
#import "ExtensionController.h"
#import "NotifycationController.h"
#import "MigrationsController.h"
#import <objc/runtime.h>

@interface ViewController2 ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray<NSString *> *> *actionList;
@end

@implementation ViewController2


- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title =  @"其他功能";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureData];
    [self configureView];
}

- (void)configureView {
    self.tableView = [UITableView new];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.frame=self.view.bounds;
}
- (void)configureData {
    
    self.actionList = [NSMutableArray array];
    
    [self.actionList addObject:@[@"反向链接", @"BacklinkController"]];
    [self.actionList addObject:@[@"加密", @"EncryptionController"]];
    [self.actionList addObject:@[@"model字段的自加操作", @"ExtensionController"]];
    [self.actionList addObject:@[@"通知", @"NotifycationController"]];
    [self.actionList addObject:@[@"数据迁移升级", @"MigrationsController"]];
}



-(void)BacklinkController{
    [self.navigationController pushViewController:[BacklinkController new] animated:true];
}
-(void)EncryptionController{
    [self.navigationController pushViewController:[EncryptionController new] animated:true];
}
-(void)ExtensionController{
    [self.navigationController pushViewController:[ExtensionController new] animated:true];
}
-(void)NotifycationController{
    [self.navigationController pushViewController:[NotifycationController new] animated:true];
}
-(void)MigrationsController{
    [self.navigationController pushViewController:[MigrationsController new] animated:true];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.actionList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    NSArray *actions = self.actionList[indexPath.row];
    cell.textLabel.text = actions[0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 55;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL funSel = NSSelectorFromString(self.actionList[indexPath.row][1]);
    if (funSel) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:funSel];
#pragma clang diagnostic pop
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
