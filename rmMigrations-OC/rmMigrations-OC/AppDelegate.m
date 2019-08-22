//
//  AppDelegate.m
//  rmMigrations-OC
//
//  Created by 黄龙山 on 2019/8/21.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"

#import "Dog.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    
    ViewController1 *vc1 = [ViewController1 new];
    ViewController2 *vc2 = [ViewController2 new];
    ViewController3 *vc3 = [ViewController3 new];
    ViewController4 *vc4 = [ViewController4 new];
    
    [tabbarController setViewControllers:@[vc1,vc2,vc3,vc4]];
    
    tabbarController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabbarController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [self creatrRealmDataBase];
    
    return YES;
}

#pragma mark - 创建数据库的配置
////v0
//- (void)creatrRealmDataBase{
//    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [docPath objectAtIndex:0];
//    NSString *filePath = [path stringByAppendingPathComponent:@"wegood_v0.realm"];//添加.realm便于识别
//    NSLog(@"realm数据库目录 = %@",filePath);
//
//    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
//    config.fileURL = [NSURL URLWithString:filePath];
//    NSLog(@"schemaVersion=%llu",config.schemaVersion);
//    [RLMRealmConfiguration setDefaultConfiguration:config];
//}

//v1
- (void)creatrRealmDataBase{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath objectAtIndex:0];
    
    //旧数据库地址
    NSString *filePathOld = [path stringByAppendingPathComponent:@"wegood_v0.realm"];//添加.realm便于识别
    NSLog(@"filePathOld = %@",filePathOld);
    NSURL *oldURL = [NSURL URLWithString:filePathOld];
    
    
    //新数据库地址
    NSString *filePathNew = [path stringByAppendingPathComponent:@"wegood_v1.realm"];
    NSLog(@"filePathNew = %@",filePathNew);
    NSURL *newURL = [NSURL URLWithString:filePathNew];
    
    [[NSFileManager defaultManager] removeItemAtURL:oldURL error:nil];
    [[NSFileManager defaultManager] copyItemAtURL:oldURL toURL:newURL error:nil];
    
    RLMMigrationBlock migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        // 这里是设置数据迁移的block
        if (oldSchemaVersion == 1) {
            /*if(currentVersion==1.0){*/
            NSLog(@"migrations");
            [migration enumerateObjects:Dog.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                [newObject[@"oneWorld"] addObject:@"数据迁移的默认值"];
            }];
        }
    };
    
    
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.schemaVersion = 1;
    configuration.migrationBlock = migrationBlock;
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    [RLMRealm defaultRealm];
    
    
    // set schemave versions and migration blocks form Realms at each path
    RLMRealmConfiguration *realmv1Configuration = [configuration copy];
    realmv1Configuration.fileURL = newURL;
    
    
    // manully migration v1Path, v2Path is migrated implicitly on access
    [RLMRealm performMigrationForConfiguration:realmv1Configuration error:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"did select");
    //    [self _changeIcon];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
