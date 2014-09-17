//
//  DetailViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-31.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString * lineNumber;//线路Id
@property (nonatomic, strong) NSMutableDictionary * detailDic;
@property (nonatomic, strong) UITableView * bigTableView;
@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, strong) NSMutableArray * imageArr;
@property (nonatomic, strong) NSMutableArray * lableArr;
@property (nonatomic, strong) NSMutableArray * expandFlagArr;
@property (nonatomic, assign) NSInteger  isCollect;

+(id)shareSingle;

@end