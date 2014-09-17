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

#import "CustomTextField.h"

@class MadeOfMeViewController;

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
     CustomTextField * zhText;
     CustomTextField * mmText;
    
}

@end

