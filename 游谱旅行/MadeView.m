//
//  MadeView.m
//  游谱旅行
//
//  Created by youpu on 14-8-5.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MadeView.h"

@implementation MadeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:70/255.0 alpha:1]];
        [self setFrame:CGRectMake(0, 0, 320, 64)];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 80, 30)];
        [_lable setText:@"我的定制"];
        [_lable setTextColor:[UIColor whiteColor]];
        [_lable setFont:[UIFont systemFontOfSize:18]];
        [self addSubview:_lable];
    }
    return self;
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
