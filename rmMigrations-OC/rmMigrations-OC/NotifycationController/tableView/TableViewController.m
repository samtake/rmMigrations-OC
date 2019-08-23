//
//  TableViewController.m
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/23.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewModel.h"

static NSString * const kCellID    = @"TableViewcell";

@interface TableViewController ()
@property(nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) RLMResults *array;
@property (nonatomic, strong) RLMNotificationToken *notification;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [[TableViewModel allObjects]sortedResultsUsingKeyPath:@"date" ascending:NO];
    
    self.title = @"TableViewExample";
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"异步更改"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backgroundAdd)];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"同步更改"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(add)];
    self.backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [self.backBtn setTitle:@"Back" forState:UIControlStateNormal];
    self.backBtn.backgroundColor=[UIColor yellowColor];
    [self.backBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableHeaderView:self.backBtn];
    
    
    // Set realm notification block
    __weak typeof(self) weakSelf = self;
    self.notification = [self.array addNotificationBlock:^(RLMResults *data, RLMCollectionChange *changes, NSError *error) {
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        UITableView *tv = weakSelf.tableView;
        // Initial run of the query will pass nil for the change information
        if (!changes) {
            [tv reloadData];
            return;
        }
        
        // changes is non-nil, so we just need to update the tableview
        [tv beginUpdates];
        [tv deleteRowsAtIndexPaths:[changes deletionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv insertRowsAtIndexPaths:[changes insertionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv reloadRowsAtIndexPaths:[changes modificationsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv endUpdates];
    }];
}

-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark - Actions

- (void)backgroundAdd
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // Import many items in a background thread
    dispatch_async(queue, ^{
        // Get new realm and table since we are in a new thread
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            for (NSInteger index = 0; index < 5; index++) {
                // Add row via dictionary. Order is ignored.
                [TableViewModel createInRealm:realm withValue:@{@"title": [self randomString],
                                                            @"date": [self randomDate]}];
            }
            [realm commitWriteTransaction];
        }
    });
}

- (void)add
{
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm beginWriteTransaction];
    [TableViewModel createInRealm:realm withValue:@[[self randomString], [self randomDate]]];
    [realm commitWriteTransaction];
}


#pragma mark - UITableView 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kCellID];
    }
    
    TableViewModel *object = self.array[indexPath.row];
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = object.date.description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RLMRealm *realm = RLMRealm.defaultRealm;
        [realm beginWriteTransaction];
        [realm deleteObject:self.array[indexPath.row]];
        [realm commitWriteTransaction];
    }
}


- (NSString *)randomString
{
    return [NSString stringWithFormat:@"随机添加的数据 %d", arc4random()];
}

- (NSDate *)randomDate
{
    return [NSDate dateWithTimeIntervalSince1970:arc4random()];
}

@end
