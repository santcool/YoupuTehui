//
//  DestinationTableViewCell.m
//  游谱旅行
//
//  Created by youpu on 14-8-28.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "DestinationTableViewCell.h"

@implementation DestinationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(130, 13, 20, 20)];
        [self addSubview:_image];
        
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
