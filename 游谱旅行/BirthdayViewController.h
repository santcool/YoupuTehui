//
//  BirthdayViewController.h
//  游谱旅行
//
//  Created by YueLink on 14-8-17.
//  Copyright (c) 2014年 YueLink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol birthDelegate;

@interface BirthdayViewController : UIViewController<UITextFieldDelegate>
{
        UIDatePicker * _datePicker;
        UIButton * finishButton ;
}
@property (nonatomic,strong) CustomTextField * field;
@property (nonatomic,strong) CustomTextField * fields;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, weak) id<birthDelegate> delegate;

@property (nonatomic, strong) NSString * birthday;

@end

@protocol birthDelegate <NSObject>

-(void)birth:(NSString *)birth;

@end