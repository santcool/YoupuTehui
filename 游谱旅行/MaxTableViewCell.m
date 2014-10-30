//
//  MaxTableViewCell.m
//  Practise
//
//  Created by youpu on 14-10-16.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MaxTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MaxTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
        CGRect newShadowFrame = CGRectMake(0, 200, 300, 100);
        newShadow.frame = newShadowFrame;
        //添加渐变的颜色组合
        newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0].CGColor,(id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor,(id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor,(id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7].CGColor,nil];
        /*
        渐变色的实现
         */
        
        self.arrowLable = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
        CALayer * upLayer = [CALayer layer];
        upLayer.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
        upLayer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_arrowLable.layer addSublayer:upLayer];
        CALayer * downLayer = [CALayer layer];
        downLayer.frame = CGRectMake(0, 35, self.frame.size.width, 0.5);
        downLayer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_arrowLable.layer addSublayer:downLayer];
        CALayer * leftLayer = [CALayer layer];
        leftLayer.frame = CGRectMake(0, 0, 0.5, 35);
        leftLayer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_arrowLable.layer addSublayer:leftLayer];
        CALayer * rightLayer = [CALayer layer];
        rightLayer.frame = CGRectMake(self.frame.size.width-20.5, 0, 1, 35);
        rightLayer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_arrowLable.layer addSublayer:rightLayer];
        [self addSubview:_arrowLable];
        
        self.header = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 25)];
        [_header setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:14]];
        [_header setTextColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]];
        [self addSubview:_header];
        
        self.behindLable = [[UILabel alloc]initWithFrame:CGRectMake(70, 8, 240, 25)];
        [_behindLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_behindLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
        [self addSubview:_behindLable];
        
        self.cityImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35, self.frame.size.width, 300)];
        CALayer * upLayerCity = [CALayer layer];
        upLayerCity.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
        upLayerCity.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_cityImage.layer addSublayer:upLayerCity];
        self.downLayerCity = [CALayer layer];
        _downLayerCity.frame = CGRectMake(0, 289.5, self.frame.size.width, 0.5);
        _downLayerCity.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_cityImage.layer addSublayer:_downLayerCity];
        CALayer * leftLayerCity = [CALayer layer];
        leftLayerCity.frame = CGRectMake(0, 0, 0.5, 300);
        leftLayerCity.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_cityImage.layer addSublayer:leftLayerCity];
        CALayer * rightLayerCity = [CALayer layer];
        rightLayerCity.frame = CGRectMake(self.frame.size.width-20.5, 0, 1, 300);
        rightLayerCity.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        [_cityImage.layer addSublayer:rightLayerCity];
        [_cityImage.layer addSublayer:newShadow];
        [self addSubview:_cityImage];
        
        self.paddingLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 325, self.frame.size.width, 10)];
        [_paddingLable setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]];
        [self addSubview:_paddingLable];
        
        self.arrowheadImage = [[UIButton alloc]initWithFrame:CGRectMake(270, 3, 30, 30)];
        [_arrowheadImage setBackgroundImage:[UIImage imageNamed:@"爆款icon_03"] forState:UIControlStateNormal];
        [self addSubview:_arrowheadImage];
        
        self.priceLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, 80, 30)];
        [_priceLable setFont:[UIFont systemFontOfSize:20]];
        [_priceLable setTextColor:[UIColor whiteColor]];
        [_priceLable setTextAlignment:NSTextAlignmentCenter];
        [_priceLable setBackgroundColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        _priceLable.layer.cornerRadius = 5;
        _priceLable.layer.masksToBounds = YES;
        [self addSubview:_priceLable];
        
        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 60, 30)];
        [_lable setFont:[UIFont systemFontOfSize:20]];
        [_lable setTextColor:[UIColor whiteColor]];
        [_priceLable addSubview:_lable];
        
        self.qiLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 7, 30, 20)];
        [_qiLable setText:@"起"];
        [_qiLable setTextColor:[UIColor whiteColor]];
        [_qiLable setFont:[UIFont systemFontOfSize:12]];
        [_priceLable addSubview:_qiLable];
        
        self.titleDes  = [[UILabel alloc]initWithFrame:CGRectMake(10, 270, 280, 50)];
        [_titleDes setTextColor:[UIColor whiteColor]];
        [_titleDes setShadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
        [_titleDes setShadowOffset:CGSizeMake(0.6f, 1.2f)];
        [_titleDes setFont:[UIFont systemFontOfSize:18]];
        _titleDes.numberOfLines = 0;
        [_titleDes setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_titleDes];
        
    }
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
