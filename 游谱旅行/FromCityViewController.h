//
//  FromCityViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-19.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol fromCityDelegate;

@interface FromCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * destinationTable;
@property (nonatomic,strong) NSMutableDictionary * dictionary;
@property (nonatomic, strong) NSString *fromcityStr;
@property (nonatomic, weak) id<fromCityDelegate> delegate;

+(id)shareSingle;

@end

@protocol fromCityDelegate <NSObject>

-(void)fromCity:(NSString *)fromCity;
-(void)fromName:(NSString *)fromName;

@end