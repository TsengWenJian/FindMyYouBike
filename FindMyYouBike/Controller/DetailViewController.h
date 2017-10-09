//
//  DetailViewController.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeModel.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totLabel;
@property (weak, nonatomic) IBOutlet UILabel *bempLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *isCollectionBtn;
@property(strong,nonatomic) BikeModel * bike;
-(void) updateUbikeStatus;

@end
