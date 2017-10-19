//
//  CustomAnnotationView.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BikeModel.h"

@interface CustomAnnotationView : MKAnnotationView
{
    UIView * containerView;
    CAShapeLayer * ovalLayer;
    CAShapeLayer * triangleLayer;
}
@property(strong,nonatomic) BikeModel * bike;
@property(strong,nonatomic) UILabel * sbiLabel;
-(void)setLayerColor:(UIColor*)color;


@end
