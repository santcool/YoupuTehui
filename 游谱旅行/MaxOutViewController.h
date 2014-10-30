//
//  MaxOutViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface MaxOutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _i;
    UIView *imageLable;
    UIPageControl * _pageControl;
    UIView * _aView;
}

@property (nonatomic, strong) NSMutableArray * maxOutArr;
@property (nonatomic, strong) NSMutableArray * everyArr;
@property (nonatomic, strong) NSMutableDictionary * maxOutDic;
@property (nonatomic, strong) UITableView * maxOutTable;
@property (nonatomic,strong) UIScrollView * scroll;
@property (nonatomic, strong) NSMutableDictionary * dictionary;

@end
