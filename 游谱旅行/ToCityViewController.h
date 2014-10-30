//
//  toCityViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-14.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol toCityDelegate;

@interface toCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController * _displayController;
}


@property (nonatomic, strong) UITableView * destinationTable;
@property (nonatomic,strong) NSMutableDictionary * dictionary;
@property (nonatomic,strong) NSMutableArray * arr;
@property (nonatomic,strong) UISearchBar * search;
@property (nonatomic,strong) UITableView * rightTable;
@property (nonatomic, strong) NSMutableArray * valueArray;
@property (nonatomic, strong) NSString * titleStr;//判断首页button标题

@property (nonatomic,strong) NSString * countryName;

@property (nonatomic, weak) id<toCityDelegate> delegate;

+(id)shareSingle;

@end

@protocol toCityDelegate <NSObject>

-(void)destination:(NSString *)region;
-(void)tocityId:(NSString *)tocity;

@end

