//
//  PersonalCenterViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PersonalCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
{
    UIImageView * image;
    NSInteger _i;
    UIPageControl * _pageControl;
    
}

@property (nonatomic, strong) UIImageView * downView;
@property (nonatomic, strong) UITableView * table;
@property (nonatomic, strong) NSMutableArray * collectArr;
@property (nonatomic, strong) NSMutableDictionary * collectDic;
@property (nonatomic, strong) UIImage * aImage;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) NSMutableDictionary * makeThing;
@property (nonatomic, strong) NSString * userIcons;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSMutableArray * numberArray;
@property (nonatomic, strong) UITableView * makeListTable;
@property (nonatomic, strong) UINavigationController * detailNavigation;
@property (nonatomic, strong) NSMutableArray * allArray;

@end


