//
//  TravelDaysViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-14.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TravelsDelegate;

@interface TravelDaysViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableDictionary * travelDic;
@property (nonatomic,strong) UITableView * travelTable;
@property (strong,nonatomic) NSString * dayStr;

@property (nonatomic,weak) id<TravelsDelegate> delegate;

+(id)shareSingle;

@end

@protocol TravelsDelegate <NSObject>

-(void)travel:(NSString *)travel;
-(void)travelId:(NSString *)travelId;

@end
