//
//  CustomTextField.m
//  游谱旅行
//
//  Created by youpu on 14-8-26.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (bounds.size.height > 15) {
        return CGRectMake(bounds.origin.x + 10.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
    }
    else{
        return CGRectMake(bounds.origin.x + 10.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (bounds.size.height > 15) {
        return CGRectMake(bounds.origin.x + 10.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
    }
    else{
        return CGRectMake(bounds.origin.x + 10.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
    }
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
