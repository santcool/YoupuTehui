//
//  PreferenceViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-8.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreferenceDelegate;

@interface PreferenceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary * withDic;
@property (nonatomic, strong) UITableView * withTable;;

@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, strong) NSMutableArray * idArray;
@property (nonatomic, strong) NSMutableArray * selectArr;

@property (nonatomic, weak) id<PreferenceDelegate> delegate;

@end

@protocol PreferenceDelegate <NSObject>

-(void)preference:(NSArray *)str;
-(void)preferenceId:(NSArray *)preferenceId;

@end