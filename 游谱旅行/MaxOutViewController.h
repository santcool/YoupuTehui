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
    MJRefreshFooterView  * _footer;
    UILabel *imageLable;
}

@property (nonatomic, strong) NSMutableArray * maxOutArr;
@property (nonatomic, strong) NSMutableDictionary * maxOutDic;
@property (nonatomic, strong) UITableView * maxOutTable;



@end
