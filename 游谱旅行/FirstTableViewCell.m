//
//  FirstTableViewCell.m
//  游谱旅行
//
//  Created by youpu on 14-7-24.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self addSubview:self.image];
        
        self.hotImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self addSubview:self.hotImage];
        
        self.fromLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 40, 20)];
        [self.fromLable setFont:[UIFont systemFontOfSize:16]];
        [_fromLable setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
        [self addSubview:self.fromLable];
        
        self.toLable = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 170,20)];
        [self.toLable setFont:[UIFont systemFontOfSize:16]];
        [_toLable setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
        [self addSubview:self.toLable];
        
   
        self.LineImage = [[UIImageView alloc] initWithFrame:CGRectMake(130, 15, 20, 20)];
        [self.LineImage setImage:[UIImage imageNamed:@"横线"]];
        [self addSubview:self.LineImage];
        
        self.timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 70, 20, 20)];
        [self.timeImage setImage:[UIImage imageNamed:@"详情页icon@2x_06"]];
        [self addSubview:self.timeImage];
        
        self.stayImage = [[UIImageView alloc] initWithFrame:CGRectMake(133, 70, 20, 20)];
        [self.stayImage setImage:[UIImage imageNamed:@"详情页icon@2x_14"]];
        [self addSubview:self.stayImage];
        
        self.flyImage = [[UIImageView alloc] initWithFrame:CGRectMake(166, 70, 20, 20)];
        [self.flyImage setImage:[UIImage imageNamed:@"详情页icon@2x_12"]];
        [self addSubview:self.flyImage];
        
        self.detailLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 32, 210, 33)];
        [self.detailLable setFont:[UIFont systemFontOfSize:12]];
        [self.detailLable  setLineBreakMode:NSLineBreakByWordWrapping];
        self.detailLable.numberOfLines = 0;
        [_detailLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [self addSubview:self.detailLable];
        
        self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(252, 70, 48, 20)];
        [self.priceLable setTextColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1]];
        [self.priceLable setFont:[UIFont systemFontOfSize:16]];
        [_priceLable setTextColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        [self addSubview:self.priceLable];
        
        self.basePrice = [[UILabel alloc] initWithFrame:CGRectMake(202, 73, 50, 17)];
        [self.basePrice setFont:[UIFont systemFontOfSize:12]];
        [self.basePrice setTextColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1]];
        [self addSubview:self.basePrice];
        
        self.baseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
        [self.basePrice addSubview:self.baseImage];
        
        
        
        self.qiLable = [[UILabel alloc] initWithFrame:CGRectMake(296, 70, 20, 20)];
        [self.qiLable setText:@"起"];
        [self.qiLable setTextColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        [self.qiLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:self.qiLable];
        
        self.genImage = [[UIImageView alloc] initWithFrame:CGRectMake(54, 14, 32, 15)];
        [self addSubview:self.genImage];
        
        self.moneyImage = [[UIImageView alloc] initWithFrame:CGRectMake(240, 72, 15, 15)];
        [self.moneyImage setImage:[UIImage imageNamed:@"钱币icon"]];
        [self addSubview:self.moneyImage];
        
        self.hotLable = [[WhiteLableText alloc] initWithFrame:CGRectMake(153, 80, 50, 10)];
        [self.hotLable setFont:[UIFont systemFontOfSize:9]];
        [self.hotLable setTextColor:[UIColor colorWithRed:255/255.0 green:199/255.0 blue:38/255.0 alpha:1]];
        [self addSubview:self.hotLable];
        
        self.textLable = [[WhiteLableText alloc] initWithFrame:CGRectMake(115, 80, 15, 10)];
        [_textLable setFont:[UIFont systemFontOfSize:9]];
        [_textLable setTextColor:[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1]];
        [self addSubview:_textLable];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
