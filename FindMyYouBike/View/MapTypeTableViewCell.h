//
//  MapTypeTableViewCell.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/8.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;

@end
