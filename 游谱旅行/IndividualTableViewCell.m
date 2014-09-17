//
//  IndividualTableViewCell.m
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "IndividualTableViewCell.h"

@implementation IndividualTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(240, 7, 50, 50)];
        _image.layer.cornerRadius = 10;
        _image.layer.masksToBounds = YES;
        [self addSubview:_image];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 190, 30)];
        [_lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_lable setTextAlignment:NSTextAlignmentRight];
        [_lable setFont:[UIFont systemFontOfSize:14]];
        _lable.numberOfLines = 0;
        _lable.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_lable];
    
        self.button = [[UIImageView alloc] initWithFrame:CGRectMake(295, 10, 20, 20)];
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
