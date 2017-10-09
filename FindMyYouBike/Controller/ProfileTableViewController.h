//
//  ProfileTableViewController.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/8.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectMapTypeDoneHander)(NSInteger index);
@interface ProfileTableViewController : UIViewController
-(void)showProfileVC:(UIViewController*)parent;
-(void)hiddeProfileVC;
@property(strong,nonatomic) selectMapTypeDoneHander selectMapTypeDone;


@end
