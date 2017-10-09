//
//  BikeModel.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "BikeModel.h"
#import "BikeLocationManager.h"



@implementation BikeModel


-(instancetype)initWithDict:(NSDictionary*)dict{
    [super self];
    
    
    self.ID = dict[@"_id"];
    self.act = dict[@"act"];
    self.sarea =  dict[@"sarea"];
    self.sna =  dict[@"sna"];
    self.tot =  dict[@"tot"];
    self.ar =  dict[@"ar"];
    self.lon = [dict[@"lng"] doubleValue];
    self.lat = [dict[@"lat"] doubleValue];
    self.sbi = dict[@"sbi"];
    self.updateTime = [self substrTime:dict[@"mday"]];
    self.bemp =  [NSString stringWithFormat:@"可還 %@",dict[@"bemp"]];
    self.isCollected = [self checkIsCollected];
    



    return self;
}
-(BOOL)checkIsCollected{
    
    if([[BikeLocationManager shared].collectionIDs containsObject:_ID]){
        return true;
    }
    return  false;
}

-(NSString *)substrTime:(NSString *)time{
    
    
    if(time != nil && ![time isEqualToString:@""] && time.length >= 12){
        
        return time = [NSString stringWithFormat:@"更新 %@:%@",[time substringWithRange:NSMakeRange(8,2)],
                       [time substringWithRange:NSMakeRange(10,2)]];
    }
    
    return @"error";;
    
}



@end

