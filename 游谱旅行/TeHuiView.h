//
//  TeHuiView.h
//  游谱特惠
//
//  Created by youpu on 14-10-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeHuiView : UIView
{
    MBProgressHUD * _progressHUD;
}

-(void)addIndicator;
-(void)removeHUD;

@end
