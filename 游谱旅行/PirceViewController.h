//
//  pirceViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-14.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PirceDelegate;

@interface PirceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * destinationTable;
@property (nonatomic,strong) NSMutableDictionary * dictionary;
@property (strong,nonatomic)NSString * priceStr;

@property (nonatomic,weak) id<PirceDelegate> delegate;
+(id)shareSingle;

@end

@protocol PirceDelegate <NSObject>

-(void)price:(NSString *)price;
-(void)priceId:(NSString *)priceId;

@end