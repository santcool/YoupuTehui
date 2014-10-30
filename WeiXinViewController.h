//
//  WeiXinViewController.h
//  游谱特惠
//
//  Created by youpu on 14/10/27.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiXinViewController : UIViewController<UITextFieldDelegate>
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
