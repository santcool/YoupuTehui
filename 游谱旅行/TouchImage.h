//
//  TouchImage.h
//  游谱旅行
//
//  Created by youpu on 14-7-24.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchImage : UIImageView

@property (nonatomic,assign) SEL action;
@property (nonatomic,strong) id target;

- (void)addTarget:(id)target action:(SEL)action;

@end
