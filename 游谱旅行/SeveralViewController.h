//
//  SeveralViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-8.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeveralDelegate;

@interface SeveralViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary * deveralDic;
@property (nonatomic, strong) UITableView * severalTable;
@property (strong,nonatomic) NSString *severalStr;

@property (nonatomic,weak) id<SeveralDelegate> delegate;
+(id)shareSingle;

@end

@protocol SeveralDelegate <NSObject>

-(void)severalName:(NSString *)str;
-(void)severalId:(NSString *)several;

@end