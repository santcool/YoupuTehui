//
//  AppDelegate.m
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    if ( [UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    
//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"youputehui#ypth" apnsCertName:@"online"];
//    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    

    //注册
    [MiPushSDK registerMiPush:self];
    //友盟统计
    [MobClick startWithAppkey:@"5448e9d0fd98c5aa1900671c" reportPolicy:REALTIME channelId:nil];
    
    //微信登陆
    [WXApi registerApp:@"wx794b9db8253ca0a1"];
    
    //shareSDK分享
    [ShareSDK registerApp:@"2e9c8aa076c6"];
    [self initializePlat];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        PrologueViewController *appStartController = [[PrologueViewController alloc] init];
        self.window.rootViewController = appStartController;
    }else {
        
        FirstViewController *main = [[FirstViewController alloc]init];
        MadeOfMeViewController * made = [[MadeOfMeViewController alloc] init];
        AddViewController *add = [[AddViewController alloc] init];
        MaxOutViewController *max = [[MaxOutViewController alloc] init];
        PersonalCenterViewController *person = [[PersonalCenterViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
        [nav setNavigationBarHidden:YES];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:made];
        UINavigationController *naviga = [[UINavigationController alloc] initWithRootViewController:add];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:max];
        UINavigationController *navigationqzy = [[UINavigationController alloc] initWithRootViewController:person];
        
        
        self.tab= [[TabBarController alloc] init];
        NSArray *arr = [NSArray arrayWithObjects:nav,navi,naviga,navigation,navigationqzy, nil];

        [_tab setViewControllers:arr];
        [_tab createButtons];
        _tab.selectedIndex = 3;
        [_window setRootViewController:_tab];
        
        [application setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [self.window makeKeyAndVisible];
    
    if (launchOptions !=nil) {
        NSDictionary * dictionary  = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString * string = [dictionary objectForKey:@"payload"];
        NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"type"]isEqualToString:@"m"]) {
            
            PushViewController * push = [[PushViewController alloc] init];
            UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:push];
            self.tab.selectedIndex = self.tab.prevSelectedIndex;
            [self.tab.selectedViewController presentViewController:na animated:YES completion:nil];
        }else if ([[dic objectForKey:@"type"]isEqualToString:@"a"]){
            
            DetailViewController *detail = [[DetailViewController alloc]init];
            detail.lineNumber = [dic objectForKey:@"lId"];
            UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:detail];
            self.tab.selectedIndex = self.tab.prevSelectedIndex;
            [self.tab.selectedViewController presentViewController:na animated:YES completion:nil];
        }
    }

    return YES;
}

-(void)initializePlat{
    
    //QQ空间R
    [ShareSDK connectQZoneWithAppKey:@"101118214" appSecret:@"1aac0ad683fd87c06bfa8165a6e6f446" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"1869670483" appSecret:@"a55f9095d2df8303a76cc0167afc353c" redirectUri:@"http://tehui.youpu.cn"];
    
    //QQ好友分享
    [ShareSDK connectQQWithQZoneAppKey:@"101118214"  qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //微信朋友圈分享
    [ShareSDK  connectWeChatTimelineWithAppId:@"wx794b9db8253ca0a1" wechatCls:[WXApi class]];
    
    //微信好友分享
    [ShareSDK connectWeChatSessionWithAppId:@"wx794b9db8253ca0a1" wechatCls:[WXApi class]];
    
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url],[ShareSDK handleOpenURL:url
                        wxDelegate:self],[WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString  *)sourceApplication
         annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url],[ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                                                         wxDelegate:self],[WXApi handleOpenURL:url delegate:self];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if ([UIApplication  sharedApplication].applicationIconBadgeNumber>0) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    NSString * string = [userInfo objectForKey:@"payload"];
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([[dic objectForKey:@"type"]isEqualToString:@"m"]) {
        
        PushViewController * push = [[PushViewController alloc] init];
        UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:push];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tab.selectedIndex = app.tab.prevSelectedIndex;
        [app.tab.selectedViewController presentViewController:na animated:YES completion:nil];
    }else if ([[dic objectForKey:@"type"]isEqualToString:@"a"]){
        
        DetailViewController *detail = [[DetailViewController alloc]init];
        detail.lineNumber = [dic objectForKey:@"lId"];
        UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:detail];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tab.selectedIndex = app.tab.prevSelectedIndex;
        [app.tab.selectedViewController presentViewController:na animated:YES completion:nil];
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [MiPushSDK bindDeviceToken:deviceToken];
    [MiPushSDK setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"]];
    [MiPushSDK subscribe:@"ios"];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
     NSLog(@"error:%@", [error description]);
}

// 请求成功
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    NSLog(@"%@",data);
}

// 请求失败
- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
   
}


//WXApiDelegate
-(void)onResp:(BaseResp *)resp{
    
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0)
    {
        NSString *code = aresp.code;
        NSDictionary *dic = @{@"code":code};
        NSDictionary * dicc = [NSDictionary dictionaryWithObject:[dic objectForKey:@"code"] forKey:@"codeQ"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"weixin" object:nil userInfo:dicc];

        }
    
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
    if (application.applicationIconBadgeNumber>0) {
        [application setApplicationIconBadgeNumber:0];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"____" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"____.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
