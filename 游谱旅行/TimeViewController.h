//
//  TimeViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-25.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeDelegate;

@interface TimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableDictionary * timeDic;
@property (nonatomic,strong) UITableView * timeTable;
@property (nonatomic, strong) NSString * titleStr;//判断首页button标题

@property (nonatomic,weak) id<TimeDelegate> delegate;
+(id)shareSingle;

@end

@protocol TimeDelegate <NSObject>

-(void)time:(NSString *)time;
-(void)timeColor:(UIColor *)normal;

@end