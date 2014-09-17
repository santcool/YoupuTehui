//
//  AppDelegate.h
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "MadeOfMeViewController.h"
#import "AddViewController.h"
#import "MaxOutViewController.h"
#import "PersonalCenterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboApi.h"
#import "WXApi.h"
#import "TabBarController.h"

#import "WeiboSDK.h"
#import "MiPushSDK.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate,UITabBarDelegate,MiPushSDKDelegate>
{
    CLLocationManager *  _locationManager;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TabBarController *tab;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
