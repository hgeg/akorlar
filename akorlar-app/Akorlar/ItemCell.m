//
//  ItemCell.m
//  Akorlar
//
//  Created by Can Bülbül on 26/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "ItemCell.h"
#import "Song.h"

@implementation ItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
