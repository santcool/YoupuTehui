//
//  WebViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-28.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol webDelegate;

@interface WebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSString * string;
@property (nonatomic, assign) id<webDelegate> delegate;

@end
@protocol webDelegate <NSObject>

-(void)fanhui;

@end