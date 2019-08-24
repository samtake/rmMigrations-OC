//
//  ViewController1.m
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/22.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "ViewController1.h"
#import "Dog.h"
#import "Person.h"

@interface ViewController1 (){
    Dog *mydog;
    UIButton *btn0;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIView *_autoWidthViewsContainer;
}

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"基本使用";
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    btn0 = [UIButton new];
    [btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn0.backgroundColor = [UIColor whiteColor];
//    [btn0 addTarget:self action:@selector(creatData) forControlEvents:UIControlEventTouchUpInside];
//    [btn0 setTitle:@"创建数据库" forState:UIControlStateNormal];
    [btn0 setTitle:@"创建数据库的配置都写在AppDelegate了" forState:UIControlStateNormal];
    
    btn1 = [UIButton new];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 addTarget:self action:@selector(creatModelObject) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"创建模型对象、并赋值" forState:UIControlStateNormal];
    
    btn2 = [UIButton new];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"保存数据" forState:UIControlStateNormal];
    
    btn3 = [UIButton new];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor whiteColor];
    [btn3 addTarget:self action:@selector(queryData) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitle:@"查询数据" forState:UIControlStateNormal];
    
    
    UIView *contentView = self.view;
    [self.view sd_addSubviews:@[btn0,btn1,btn2,btn3]];
    
    btn0.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 100)
    .heightIs(50);
    
    btn1.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(btn0, 30)
    .heightIs(50);
    
    btn2.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(btn1, 30)
    .heightIs(50);
    
    
    btn3.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(btn2, 30)
    .heightIs(50);
    
    
    [self setupAutoWidthViewsWithCount:4 margin:10];
    
}



// 设置一排固定间距自动宽度子view
- (void)setupAutoWidthViewsWithCount:(NSInteger)count margin:(CGFloat)margin
{
    _autoWidthViewsContainer = [UIView new];
    _autoWidthViewsContainer.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_autoWidthViewsContainer];
    
    NSArray *aryTitles = @[@"one",@"more",@"all",@"<<删除"];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        [_autoWidthViewsContainer addSubview:button];
        button.sd_layout.autoHeightRatio(0.4); // 设置高度约束
        [temp addObject:button];
        button.tag=i;
        [button setTitle:aryTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteClick:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    _autoWidthViewsContainer.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(btn3, 30);
    
    // 此步设置之后_autoWidthViewsContainer的高度可以根据子view自适应
    [_autoWidthViewsContainer setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:margin horizontalMargin:margin verticalEdgeInset:5 horizontalEdgeInset:10];
    
}


#pragma mark - 创建数据库
-(void)creatData{
    NSLog(@"创建数据库");
    [[NSFileManager defaultManager] removeItemAtURL:[RLMRealmConfiguration defaultConfiguration].fileURL error:nil];
}
#pragma mark - 创建模型对象、并赋值
-(void)creatModelObject{
    // Create a standalone object
   mydog  = [[Dog alloc] init];
    
    // Set & read properties
    mydog.name = @"创建模型对象、并赋值 Rex";
    mydog.age = 9;
    NSLog(@"创建模型对象、并赋值 mydog=%@",mydog);
}


#pragma mark - 保存数据
-(void)addData{
    if (!mydog) {
        NSLog(@"请创建模型对象、并赋值");
        return;
    }
    // Realms are used to group data together
    RLMRealm *realm = [RLMRealm defaultRealm]; // Create realm pointing to default file
    
    // Save your object
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm addObject:mydog];
    [realm commitWriteTransaction];
    NSLog(@"保存数据");
}

#pragma mark - 查询数据
-(void)queryData{
    NSLog(@"查询数据");
    // Query
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *results = [Dog objectsInRealm:realm where:@"name contains 'x'"];
    
    // Queries are chainable!
    RLMResults *results2 = [results objectsWhere:@"age > 8"];
    NSLog(@"Number of dogs: %li", (unsigned long)results2.count);
    
//    // Link objects
//    Person *person = [[Person alloc] init];
//    person.name = @"Tim";
//    [person.dogs addObject:mydog];
//
//    [realm beginWriteTransaction];
//    [realm addObject:person];
//    [realm commitWriteTransaction];
//
//    // Multi-threading
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @autoreleasepool {
//            RLMRealm *otherRealm = [RLMRealm defaultRealm];
//            RLMResults *otherResults = [Dog objectsInRealm:otherRealm where:@"name contains 'Rex'"];
//            NSLog(@"Number of dogs: %li", (unsigned long)otherResults.count);
//        }
//    });
}

-(void)deleteClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self deleteOne];
            break;
            
        case 1:
            [self deleteMore];
            break;
            
        case 2:
            [self deleteAll];
            break;
            
        default:
            break;
    }
}
#pragma mark - deleteOne
-(void)deleteOne{
    if (!mydog) {
        NSLog(@"请创建模型对象、并赋值");
        return;
    }
    return;//数据库空值删除一个时报错，暂未弄明白
    NSLog(@"删除一个");
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    // 删除单条记录:传进模型对象即可
    [realm deleteObject:mydog];
    
    [realm commitWriteTransaction];
}
#pragma mark - deleteMore
-(void)deleteMore{
    NSLog(@"删除多个");
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    // 删除多条记录：传进查询结果集合
    RLMRealm *otherRealm = [RLMRealm defaultRealm];
    RLMResults *otherResults = [Dog objectsInRealm:otherRealm where:@"name contains 'Rex'"];
    [realm deleteObjects:otherResults];
    [realm commitWriteTransaction];
}
#pragma mark - deleteAll
-(void)deleteAll{
    NSLog(@"删除全部");
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    // 删除所有记录
    [realm deleteAllObjects];
    
    [realm commitWriteTransaction];
}

@end
