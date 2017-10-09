//
//  ListTableViewCell.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/6.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UILabel *sbiLabel;
@property (weak, nonatomic) IBOutlet UILabel *bempLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;

@end
