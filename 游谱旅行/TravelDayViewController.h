//
//  TravelDayViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-25.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TravelDelegate;

@interface TravelDayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableDictionary * travelDic;
@property (nonatomic,strong) UITableView * travelTable;
@property (nonatomic, strong) NSString * titleStr;//判断首页button标题

@property (nonatomic,weak) id<TravelDelegate> delegate;
+(id)shareSingle;

@end

@protocol TravelDelegate <NSObject>

-(void)travel:(NSString *)travel;
-(void)travelColor:(UIColor *)normal;

@end