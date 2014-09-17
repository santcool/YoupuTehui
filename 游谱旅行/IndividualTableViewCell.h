//
//  IndividualTableViewCell.h
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndividualTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * image;
@property (nonatomic, strong) UILabel * lable;
@property (nonatomic, strong) UIImageView * button;

@property (nonatomic, strong) UILabel * cityLable;
@property (nonatomic, strong) UILabel * sexLable;
@property (nonatomic, strong) UILabel * phoneLable;
@property (nonatomic, strong) UILabel * lastLable;

@end
