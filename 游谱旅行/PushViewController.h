//
//  PushViewController.h
//  游谱特惠
//
//  Created by youpu on 14-9-18.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * pushTable;
@property (nonatomic, strong) NSMutableArray * array;

@end
