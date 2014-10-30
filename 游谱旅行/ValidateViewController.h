//
//  ValidateViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-26.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MobileDelegate;

@interface ValidateViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic, strong) UITextField * field;

@property (nonatomic, strong) NSString * phoneMobile;

@property (nonatomic, weak) id<MobileDelegate> delegate;

@end

@protocol MobileDelegate <NSObject>

-(void)mobile:(NSString *)mobile;

@end