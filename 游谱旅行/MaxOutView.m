//
//  MaxOutView.m
//  游谱特惠
//
//  Created by youpu on 14/10/24.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MaxOutView.h"

@implementation MaxOutView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setBackgroundColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(98, 30, 124, 26)];
        [image setImage:[UIImage imageNamed:@"顶部logo"]];
        [self addSubview:image];
        
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
