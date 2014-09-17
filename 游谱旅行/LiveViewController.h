//
//  LiveViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol liveDelegate;

@interface LiveViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString * nowAddress;
@property (nonatomic, strong) NSMutableArray * addressArray;
@property (nonatomic, strong) UITableView * addressTable;

@property (nonatomic, weak) id<liveDelegate> delegate;

@property (nonatomic, strong) NSString * liveHere;

+(id)shareSingle;

@end

@protocol liveDelegate <NSObject>

-(void)address:(NSString *)address;

@end