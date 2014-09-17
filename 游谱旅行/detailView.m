//
//  detailView.m
//  游谱旅行
//
//  Created by youpu on 14-8-1.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "detailView.h"
#import "MainViewController.h"

#define BAR_COLOR [UIColor colorWithRed:224/255.0 green:89/255.0 blue:70/255.0 alpha:1]

@implementation detailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:BAR_COLOR];
        [self setFrame:CGRectMake(0, 0, 320, 64)];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 70, 40)];
        [self addSubview:_button];
        self.backImage = [[TouchImage alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
        [_button addSubview:_backImage];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 80, 30)];
        [_lable setText:@"特惠详情"];
        [_lable setTextColor:[UIColor whiteColor]];
        [_lable setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_lable];
        
        UIButton * fenxiang = [[UIButton alloc]initWithFrame:CGRectMake(270, 30, 40, 30)];
        [self addSubview:fenxiang];
        self.image = [[TouchImage alloc] initWithFrame:CGRectMake(5, 0,  30, 30)];
        [fenxiang addSubview:_image];
        
        UIButton * collect = [[UIButton alloc]initWithFrame:CGRectMake(230, 29, 40, 30)];
        [self addSubview:collect];
        self.collectImage = [[TouchImage alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [collect addSubview:_collectImage];
        
        
        
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
