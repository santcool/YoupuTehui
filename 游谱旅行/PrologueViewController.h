//
//  PrologueViewController.h
//  游谱特惠
//
//  Created by youpu on 14-10-8.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+SplitImageIntoTwoParts.h"
#import "AppDelegate.h"
#import "MiPushSDK.h"

@interface PrologueViewController : UIViewController<UIScrollViewDelegate,MiPushSDKDelegate>

@property (nonatomic,strong) UIImageView *left;
@property (nonatomic,strong) UIImageView *right;
@property (strong, nonatomic) UIButton *gotoMainViewBtn;

@end
