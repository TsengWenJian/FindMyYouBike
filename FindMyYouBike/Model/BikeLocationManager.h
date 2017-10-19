//
//  BikeLocationManager.h
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#define YOUBIKE_URL  @"http://data.tycg.gov.tw/api/v1/rest/datastore/a1b4714b-3b75-4ff8-a8f2-cc377e4eaa0f?format=json"


typedef void (^DoneHandle)(NSError *error);

@interface BikeLocationManager : NSObject

@property(strong,nonatomic) NSMutableArray* bikes;
@property(strong,nonatomic) NSMutableArray* collectionIDs;

+(instancetype)shared;
-(void)getAllBikeLocation:(DoneHandle) done;
-(NSArray*)sortedBikesWithDistance:(NSArray *)bikes;

@end
