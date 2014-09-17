//
//  MakeListTableViewCell.m
//  游谱旅行
//
//  Created by youpu on 14-8-30.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MakeListTableViewCell.h"

@implementation MakeListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.numberImage =[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:_numberImage];
        
        self.DesLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 50, 30)];
        [_DesLable setText:@"目的地:"];
        [_DesLable setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_DesLable];
        
        self.cityName = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
        [_cityName setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_cityName];
        
        self.chufaLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 60, 20)];
        [_chufaLable setText:@"出发时间:"];
        [_chufaLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_chufaLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_chufaLable];
        
        self.specificLable = [[UILabel alloc]initWithFrame:CGRectMake(105, 30, 180, 20)];
        [_specificLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_specificLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_specificLable];
        
        self.xingchengLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 50, 20)];
        [_xingchengLable setText:@"行程:"];
        [_xingchengLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_xingchengLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_xingchengLable];
        
        self.daysLable = [[UILabel alloc] initWithFrame:CGRectMake(83, 50, 100, 20)];
        [_daysLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_daysLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_daysLable];
        
        self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, 50, 20)];
        [_priceLable setText:@"预算:"];
        [_priceLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_priceLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_priceLable];
        
        self.budgetLable = [[UILabel alloc] initWithFrame:CGRectMake(83, 70, 50, 20)];
        [_budgetLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_budgetLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_budgetLable];
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
