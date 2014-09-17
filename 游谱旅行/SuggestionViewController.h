//
//  SuggestionViewController.h
//  游谱旅行
//
//  Created by youpu on 14-9-2.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString * titleName;
@property (nonatomic, strong) UITextView * field;
@property (nonatomic, strong) UITextField * emailField;

@end
