//
//  MadeOfMeViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MJRefresh.h"

@interface MadeOfMeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _i;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger _page;
}

//上方button数据源
@property (nonatomic, strong) NSMutableDictionary * madeDic;
//tableview数据源
@property (nonatomic, strong) NSMutableArray * tableViewDic;
//tableview
@property (nonatomic, strong) UITableView * madeTableView;
@property (nonatomic, strong) UITableView * secondTable;
@property (nonatomic, strong) UITableView * thirdTable;
@property (nonatomic, strong) UITableView * forthTable;
//按钮下方横条,随按钮点击移动
@property (strong ,nonatomic) UIImageView * downView;
@property (nonatomic, strong) NSString * madeString;//用户的定制ID
@property (nonatomic, strong) NSMutableArray * array;//存放所有orderID

@property (nonatomic, strong) NSString * qzyMember;

@end
