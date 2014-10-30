//
//  LoginViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-13.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ForgetPassViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "SinaEmailViewController.h"
#import "WXApi.h"

#import "CustomTextField.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate,TencentSessionDelegate,TencentLoginDelegate,WXApiDelegate>
{
     CustomTextField * zhText;
     CustomTextField * mmText;
    
}
@property (nonatomic,strong) NSString * openId;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * nickName;
@property (nonatomic,strong) NSString * myImage;

@end
