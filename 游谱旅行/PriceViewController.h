//
//  DestinationViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-24.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriceDelegate;

@interface PriceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * destinationTable;
@property (nonatomic,strong) NSMutableDictionary * dictionary;
@property (nonatomic, strong) NSString * titleStr;//判断首页button标题

@property (nonatomic,weak) id<PriceDelegate> delegate;

+ (id)shareSingle;

@end

@protocol PriceDelegate <NSObject>

-(void)price:(NSString *)price;

-(void)color:(UIColor *)normal;

@end