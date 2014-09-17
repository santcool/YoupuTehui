//
//  AddTableViewCell.m
//  游谱旅行
//
//  Created by youpu on 14-8-8.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "AddTableViewCell.h"

@implementation AddTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 190, 30)];
        [_lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_lable setFont:[UIFont systemFontOfSize:12]];
        [_lable setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_lable];
        
        self.twoLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 200, 30)];
        [_twoLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_twoLable setFont:[UIFont systemFontOfSize:12]];
        [_twoLable setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_twoLable];
        
        self.button = [[UIImageView alloc] initWithFrame:CGRectMake(290, 10, 20, 20)];
        [_button setImage:[UIImage imageNamed:@"大于号"]];
        [self addSubview:_button];
        
        
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
