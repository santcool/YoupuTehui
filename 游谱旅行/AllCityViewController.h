//
//  AllCityViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-29.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol allDelegate;

@interface AllCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableDictionary * dictionary;
@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSString * nowName;

@property (nonatomic, assign) id<allDelegate> delegate;

+(id)shareSingle;

@end

@protocol allDelegate <NSObject>

-(void)cityNames:(NSString *)names;
-(void)createscroll;

@end