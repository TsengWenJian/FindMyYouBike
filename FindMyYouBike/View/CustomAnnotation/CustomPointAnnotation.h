//
//  CustomPointAnnotation.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BikeModel.h"

@interface CustomPointAnnotation : MKPointAnnotation
@property(strong,nonatomic) BikeModel * bike;
@end
