//
//  LisetViewController.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/6.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeModel.h"

typedef void (^selectItemDoneHandler)(BikeModel * reslut);
@interface LisetViewController : UIViewController
@property(strong,atomic) selectItemDoneHandler selectItemDone;
-(void)updateTableView;

@end
