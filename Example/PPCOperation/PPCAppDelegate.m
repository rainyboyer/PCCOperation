//
//  PPCAppDelegate.m
//  PPCOperation
//
//  Created by pen on 05/31/2016.
//  Copyright (c) 2016 pen. All rights reserved.
//

#import "PPCAppDelegate.h"
#import "PPCViewController.h"
#import "SMMOperationHandler.h"
#import "SMMBaseApiEngine.h"
#import "PPCDefine.h"
#import "SMMPushArticleAction.h"

//#define ApiUrl @"http://192.168.100.200:8009/index.php?g=appApi&m=mapi&a=index"
//#define DownLoadUrl @"http://192.168.100.200:8009/tpl/appHtml"
#define ApiUrl @"http://124.172.184.212:8009/index.php?g=appApi&m=mapi&a=index"
#define DownLoadUrl @"http://124.172.184.212:8009/tpl/appHtml"
@interface PPCAppDelegate ()<SMMOperationHandlerDelegate>
@property (nonatomic, assign) NSInteger urlCount;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, assign) NSInteger typeCount;
@end
@implementation PPCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    PPCViewController *vc = [[PPCViewController alloc]init];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window setRootViewController:nc];
    [self.window makeKeyAndVisible];
    
    [self registerHandler];
    [self netWorking];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//  注册处理器
- (void)registerHandler
{
    SMMPushArticleAction *articleAction = [[SMMPushArticleAction alloc]init];
    [articleAction load];
}

//  下载需要更新的url的json文件
- (void)netWorking
{
    if (!_loadingView)
    {
        _loadingView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        [_loadingView setBackgroundColor:[UIColor orangeColor]];
        [self.window.rootViewController.view addSubview:_loadingView];
    }
    
    __weak typeof(self) weakSelf = self;
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *json)
    {
        NSDictionary *fileDic = json[@"tpl"];
        [fileDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             _typeCount++;
             NSString *fileType = [[NSUserDefaults standardUserDefaults] objectForKey:key];
             NSString *keyVersion = fileDic[key][@"version"];
             NSString *urlVersion = fileDic[key][@"url"];
             if (![fileType isEqualToString:keyVersion] && urlVersion.length > 0)
             {
                 SMMOperationHandler *handler = [[SMMOperationHandler alloc]initWithDownloadUrlString:DownLoadUrl];
                 handler.delegate = weakSelf;
                 [handler getFileDictionaryWithUrl:[NSURL URLWithString:urlVersion] version:keyVersion key:key];
             }
             else
             {
                 NSLog(@"%@版本相同", key);
                 if (_typeCount == 4)
                 {
                     [_loadingView removeFromSuperview];
                 }

             }
         }];
    };
    
    void (^onFailure)(NSError *) = ^(NSError *error)
    {
        NSLog(@"error: %@", error.description);
    };
    
    NSDictionary *dic = @{@"html":[[NSUserDefaults standardUserDefaults] objectForKey:@"html"]?:@"0",
                          @"css":[[NSUserDefaults standardUserDefaults] objectForKey:@"css"]?:@"0",
                          @"js":[[NSUserDefaults standardUserDefaults] objectForKey:@"js"]?:@"0",
                          @"else":[[NSUserDefaults standardUserDefaults] objectForKey:@"else"]?:@"0"};
    
    SMMBaseApiEngine *engine = [[SMMBaseApiEngine alloc]initWithBaseUrl:ApiUrl secretKey:nil];
    [engine requestService:@"meta.get_app_tpl_version" parameters:dic onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - SMMOperationHandler Delegate
- (void)operationHandler:(SMMOperationHandler *)handler version:(NSString *)version key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _urlCount++;
    if (_urlCount == 4)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingView removeFromSuperview];
//        });
        
    }
}

- (void)downloadFailWithOperationHandler:(SMMOperationHandler *)handler fileUrl:(NSURL *)url version:(NSString *)version key:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    void (^downloadAction)(UIAlertAction *) = ^(UIAlertAction *action) {
        SMMOperationHandler *handler = [[SMMOperationHandler alloc]initWithDownloadUrlString:DownLoadUrl];
        handler.delegate = weakSelf;
        [handler getFileDictionaryWithUrl:url version:version key:key];
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"文件下载失败"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:downloadAction];
        [alertController addAction:okAction];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    });
    
}

@end
