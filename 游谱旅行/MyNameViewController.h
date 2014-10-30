//
//  MyNameViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myDelegate;

@interface MyNameViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) CustomTextField * field;
@property (nonatomic, weak) id<myDelegate> delegate;

@property (nonatomic, strong) NSString * myName;

@end

@protocol myDelegate <NSObject>

-(void)names:(NSString *)name;

@end
