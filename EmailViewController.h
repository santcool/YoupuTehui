//
//  EmailViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-31.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTextField.h"

@interface EmailViewController : UIViewController
{
    CustomTextField * zhText;
    CustomTextField * mmText;
    UIButton * yanzheng;
    UIButton * login;
}

@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * userIcon;

@end
