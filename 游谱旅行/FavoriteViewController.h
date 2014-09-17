//
//  FavoriteViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  favoriteDelegate;

@interface FavoriteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString * favorite;
@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, strong) UITableView * table;
@property (nonatomic, strong) NSMutableArray * favoriteArr;
@property (nonatomic, strong) NSMutableArray * favoriteId;

@property (nonatomic, weak) id<favoriteDelegate> delegate;

@property (nonatomic, strong) NSString * favoriteNow;

@end

@protocol favoriteDelegate <NSObject>

-(void)favorite:(NSArray *)favorite;

@end