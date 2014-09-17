//
//  FirstTableViewCell.h
//  游谱旅行
//
//  Created by youpu on 14-7-24.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteLableText.h"

@interface FirstTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * image;
@property (nonatomic, strong) UIImageView * hotImage;
@property (nonatomic, strong) UILabel * fromLable;
@property (nonatomic,strong) UILabel * toLable;
@property (nonatomic,strong) UIImageView * LineImage;
@property (nonatomic, strong) UIImageView * timeImage;
@property (nonatomic,strong) UIImageView * stayImage;
@property (nonatomic,strong) UIImageView *flyImage;
@property (nonatomic,strong) UILabel * detailLable;
@property (nonatomic,strong) UILabel * priceLable;
@property (nonatomic,strong) UILabel *basePrice;
@property (nonatomic,strong) UIImageView * baseImage;
@property (nonatomic,strong) UILabel *qiLable;

@property (nonatomic,strong) UIImageView * genImage;
@property (nonatomic,strong) UIImageView * moneyImage;

@property (nonatomic,strong) WhiteLableText *textLable;
@property (nonatomic, strong) WhiteLableText * hotLable;


@end
