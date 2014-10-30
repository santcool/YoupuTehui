//
//  SignUpViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-13.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) CustomTextField * zhText;
@property (nonatomic, strong) CustomTextField * yxText;

@end
