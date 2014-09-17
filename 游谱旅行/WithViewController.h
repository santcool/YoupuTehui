//
//  WithViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-8.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol withDelegate;

@interface WithViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) NSMutableDictionary * withDic;
@property (nonatomic, strong) UITableView * withTable;
@property (nonatomic, strong) NSString * withStr;

@property (nonatomic,weak) id<withDelegate> delegate;
+(id)shareSingle;

@end

@protocol withDelegate <NSObject>

-(void)with:(NSString *)str;

-(void)withId:(NSString *)withId;

@end