//
//  PushView.m
//  游谱特惠
//
//  Created by youpu on 14-9-23.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "PushView.h"

@implementation PushView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(98, 30, 124, 26)];
        [image setImage:[UIImage imageNamed:@"顶部logo"]];
        [self addSubview:image];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 70, 40)];
        [self addSubview:_button];
        self.backImage = [[TouchImage alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
        [_button addSubview:_backImage];

    }
        return self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
