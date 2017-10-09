//
//  ListTableViewCell.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/6.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    for (UIView * containView in _containerLabelView){
        [containView layer].cornerRadius = 5;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
