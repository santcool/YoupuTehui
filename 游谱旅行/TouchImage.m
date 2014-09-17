//
//  TouchImage.m
//  游谱旅行
//
//  Created by youpu on 14-7-24.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "TouchImage.h"

@implementation TouchImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //开启用户交互
        [self setUserInteractionEnabled:YES];
        
        
    }
    return self;
}

-(void)addTarget:(id)target action:(SEL)action{
    
    self.target = target;
    self.action = action;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.target performSelector:self.action withObject:self];
    
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
