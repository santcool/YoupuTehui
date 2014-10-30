//
//  ExplodeViewController.h
//  游谱特惠
//
//  Created by youpu on 14-10-17.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExplodeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _i;
    UIView *imageLable;
    MBProgressHUD * _progressHUD;
    NSString * _serverTime;
}

@property (nonatomic, strong) NSMutableArray * maxOutArr;
@property (nonatomic, strong) NSMutableArray * everyArr;
@property (nonatomic, strong) NSMutableDictionary * maxOutDic;
@property (nonatomic, strong) UITableView * maxOutTable;

@end
