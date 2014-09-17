//
//  MainViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"
#import "DestinationViewController.h"
#import "PriceViewController.h"
#import "FirstTableViewCell.h"
#import "TravelDayViewController.h"
#import "TimeViewController.h"
#import "WhiteLableText.h"
#import "WebViewController.h"
#import "AllCityViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,MJRefreshBaseViewDelegate,DestinationDelegate,PriceDelegate,TravelDelegate,TimeDelegate,UIAlertViewDelegate,allDelegate,UIApplicationDelegate,webDelegate>{
    
    UIPageControl * _pageControl;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger _i;
    NSInteger _j;
    NSInteger _k;
    NSInteger _a;
    NSInteger _rn;
    NSInteger _detailNumber;
    UIButton * _button;
    
}

@property (nonatomic, strong) NSMutableDictionary * dictionary;//滑动视图数据源
@property (nonatomic, strong) NSMutableDictionary * lineDic;//线路所有数据源
@property (nonatomic,strong) NSMutableArray * refreshArray;//刷新后的数据源
@property (nonatomic,strong) NSMutableArray * rnArray;

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIScrollView * scroll;

@property (nonatomic, strong) NSString * toCityName;
@property (nonatomic, strong) NSString * idString;
@property (nonatomic, strong) NSString * dayString;
@property (nonatomic, strong) NSString * timeString;
@property (nonatomic, strong) NSString * fromString;
@property (nonatomic, strong) NSString * fromCityId;

@property (nonatomic, strong) NSString * nameString;//返回筛选条件的text

@property (nonatomic, strong) NSString *  kindName;

@end
