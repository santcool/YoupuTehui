//
//  SexViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sexDelegate;

@interface SexViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSMutableArray * sexArray;
@property (nonatomic, strong) UITableView * sexTable;

@property (nonatomic, weak) id<sexDelegate> delegate;

@property (nonatomic, strong) NSString * sexAndLove;
+(id)shareSingle;

@end

@protocol sexDelegate <NSObject>

-(void)sex:(NSString *)sex;

@end