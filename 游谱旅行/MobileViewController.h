//
//  MobileViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-26.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * nowNumber;
@property (nonatomic, strong) UITextField * field;


@end
