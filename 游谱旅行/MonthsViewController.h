//
//  MonthsViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-14.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MonthsDelegate;

@interface MonthsViewController : UIViewController<UITextFieldDelegate>
{
    UIButton * timeButton;
    UIButton * finishButton ;
    UIDatePicker * _datePicker;
    NSInteger _i;
    NSInteger _j;
}

@property (nonatomic,strong) NSMutableDictionary * timeDic;
@property (nonatomic,strong) UITableView * timeTable;
@property (nonatomic,strong) UITextField * field;
@property (nonatomic,strong) UITextField * fields;
@property (nonatomic,strong) NSString * leftTime;
@property (nonatomic,strong) NSString * rightTime;

@property (nonatomic, assign) BOOL exit;

@property (nonatomic,weak) id<MonthsDelegate> delegate;

@end

@protocol MonthsDelegate <NSObject>

-(void)time:(NSString *)startTime arrive:(NSString *)finishTime exit:(BOOL)exit;

-(void)whatever:(NSString *)string exit:(BOOL)exit;

@end