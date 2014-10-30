//
//  TabBarController.m
//  FanBox
//
//  Created by YueLink on 14-8-13.
//  Copyright (c) 2014年 ZYL. All rights reserved.
//

#import "TabBarController.h"

static TabBarController * tab = nil;

@interface TabBarController ()

@end

@implementation TabBarController

+ (id)shareSingle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tab = [[self alloc] initWithNibName:nil bundle:nil];
    });
    
    return tab;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _i =0;
        _prevSelectedIndex = 0;
        _isOrNo = 3;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTabbar];
}

//创建自定义tabBar
- (void)createTabbar
{
    self.tabBar.hidden = YES; //隐藏原先的tabBar
    
    CGFloat tabBarViewY = self.view.frame.size.height - 49;
    self.tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabBarViewY, self.view.frame.size.width, 49)];
    [_tabBarView setBackgroundColor:[UIColor colorWithRed:53/255.0 green:58/255.0 blue:66/255.0 alpha:1.0f]];//背景颜色
    [_tabBarView setUserInteractionEnabled:YES];//打开用户交互
    
    [self.view addSubview:_tabBarView];
}

//创建tabBar上的按钮
- (void)createButtons
{
    //初始化按钮图片数组
    _imageArray = [NSArray arrayWithObjects:@{@"normal": [UIImage imageNamed:@"首页底部bar_01_10"],@"selected":[UIImage imageNamed:@"首页底部bar_01_05"]},@{@"normal": [UIImage imageNamed:@"首页底部bar_01_08"],@"selected":[UIImage imageNamed:@"首页底部bar_01_03"]},@{@"normal": [UIImage imageNamed:@"加号切图"],@"selected":[UIImage imageNamed:@"加号点击后"]},@{@"normal": [UIImage imageNamed:@"首页底部bar_01_07"],@"selected":[UIImage imageNamed:@"首页底部bar_01_02"]},@{@"normal": [UIImage imageNamed:@"首页底部bar_01_06"],@"selected":[UIImage imageNamed:@"首页底部bar_01_01"]}, nil];
    
    //根据数组元素个数循环创建按钮
    for (int i = 0; i < [_imageArray count]; i++) {
        CGFloat space = (300 - 49*[_imageArray count])/([_imageArray count] - 1.0);
        int x = 15 + i*(space+49);
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(x,8,30,30)];
        NSDictionary * imageDic = [_imageArray objectAtIndex:i];
        [button setImage:[imageDic objectForKey:@"normal"] forState:UIControlStateNormal];
        [button setImage:[imageDic objectForKey:@"selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(actionOfButtons:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [_tabBarView addSubview:button];
        
        //默认选中第一个按钮
        if (i == 0) {
            [button setFrame:CGRectMake(i+10, 11, 30, 30)];
        }if (i==1) {
            [button setFrame:CGRectMake(i+70, 11, 30, 30)];
        }
        if (i==2) {
            [button setFrame:CGRectMake(x-15, 0, 70, 49)];
        }if (i==3) {
             button.selected = YES;
            [button setFrame:CGRectMake(x+15, 11, 30, 30)];
        }if (i==4) {
            [button setFrame:CGRectMake(x+10, 11, 30, 30)];
        }
    }}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _prevSelectedIndex = self.selectedIndex;
    
    [super setSelectedIndex:selectedIndex];
    
    for (int i = 0; i < [_imageArray count]; i++) {
        UIButton * buuton = (UIButton *)[_tabBarView viewWithTag:100+i];
        buuton.selected = i == self.selectedIndex;
    }
}

//tabBar按钮点击事件
- (void)actionOfButtons:(UIButton *)sender
{
    _prevSelectedIndex = sender.tag - 100;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"] == nil && sender.tag==104) {
        LoginViewController * login = [[LoginViewController alloc] init];
        UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:na animated:NO completion:nil];
    } else {
        self.selectedIndex = sender.tag - 100;

     
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"] == nil && sender.tag==103) {
        _isOrNo = 3;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"] == nil && sender.tag==100) {
        _isOrNo = 1;
    }
}


@end
