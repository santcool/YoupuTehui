//
//  DetailTableViewCell.m
//  游谱旅行
//
//  Created by youpu on 14-8-14.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.frontImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self addSubview:_frontImage];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 100, 30)];
        [_lable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:16]];
        
        [self addSubview:_lable];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 280, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self addSubview:self.contentLabel];
        
        self.jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(260, 10, 20, 20)];
        [self addSubview:_jtImage];
        
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
