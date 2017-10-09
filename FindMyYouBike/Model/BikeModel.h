//
//  BikeModel.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BikeModel : NSObject
@property(strong,nonatomic) NSString * ID;
@property(strong,nonatomic) NSString * sarea;
@property(strong,nonatomic) NSString * sna;
@property(strong,nonatomic) NSString * tot;
@property(strong,nonatomic) NSString * ar;
@property(strong,nonatomic) NSString * act;
@property(nonatomic) double  lat;
@property(nonatomic) double  lon;
@property(strong,nonatomic) NSString * sbi;
@property(strong,nonatomic) NSString * updateTime;
@property(strong,nonatomic) NSString * bemp;
@property(nonatomic) double  distance;
@property(nonatomic)BOOL isCollected;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end
