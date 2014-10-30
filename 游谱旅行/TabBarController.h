//
//  TabBarController.h
//  FanBox
//
//  Created by YueLink on 14-8-13.
//  Copyright (c) 2014年 ZYL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TabBarController : UITabBarController<UITabBarControllerDelegate,UIAlertViewDelegate>
{
    //按钮图片的数组
    NSArray * _imageArray;
}

@property (nonatomic, strong) UIView * tabBarView;//自定义的tabBar
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) NSInteger prevSelectedIndex;
@property (nonatomic, assign) NSInteger isOrNo;
@property (nonatomic, assign) NSInteger mainSelected;


- (void)createTabbar;
//创建tabBar上的按钮
- (void)createButtons;

+(id)shareSingle;

@end
