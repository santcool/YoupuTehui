//
//  DestinationViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-25.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinationTableViewCell.h"

@protocol DestinationDelegate;

@interface DestinationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
        UIView * _aView;
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

@property (nonatomic, weak) id<DestinationDelegate> delegate;

+ (id)shareSingle;

@end

@protocol DestinationDelegate <NSObject>

-(void)destination:(NSString *)region;
-(void)desColor :(UIColor *)normal;

@end

