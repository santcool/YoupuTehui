//
//  TeHuiView.m
//  游谱特惠
//
//  Created by youpu on 14-10-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "TeHuiView.h"

@implementation TeHuiView

-(void)addIndicator
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:_progressHUD];
    [self bringSubviewToFront:_progressHUD];
    [_progressHUD setMode:MBProgressHUDModeIndeterminate];
    [_progressHUD setLabelText:@"加载中..."];
    [_progressHUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}
-(void) myProgressTask{
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress -=0.01f;
        _progressHUD.progress = progress;
        usleep(50000);
    }
}
-(void)removeHUD{
    [_progressHUD hide:YES];
    [_progressHUD removeFromSuperViewOnHide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
