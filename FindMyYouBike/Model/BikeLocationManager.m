//
//  BikeLocationManager.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "BikeLocationManager.h"
#import <AFNetworking.h>
#import "BikeModel.h"
#import <CoreLocation/CoreLocation.h>

@implementation BikeLocationManager
{
    AFHTTPSessionManager * manager;
}

+(instancetype)shared{
    
    static dispatch_once_t onceToken;
    static BikeLocationManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [BikeLocationManager new];
    
    });
    
    return instance;
}
-(instancetype)init{
    [super self];
    
      NSArray * ids = [self getCollectionIDs];
     _bikes = [NSMutableArray new];
    
    if(ids != nil){
        
        _collectionIDs = [[NSMutableArray alloc] initWithArray:ids];
        
    }else{
        
        _collectionIDs = [NSMutableArray new];
    }
    
    return  self;
}

-(NSArray*)getCollectionIDs{
    return  [[NSUserDefaults standardUserDefaults] valueForKey:@"collectIDs"];
    
}
-(void)setCollectionIDs:(NSArray*)ids{
    NSArray * myIDs = ids;
    [[NSUserDefaults standardUserDefaults] setObject:myIDs forKey:@"collectIDs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)getAllBikeLocation:(DoneHandle) done{
    

    if(!manager)
    {
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }

    NSDictionary *dict = @{@"limit":@"1000"};
    NSURL *URL = [NSURL URLWithString:YOUBIKE_URL];
    [manager GET:URL.absoluteString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [_bikes removeAllObjects];
        NSLog(@"------getAllBikeLocation--------");
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSArray * result = responseObject[@"result"][@"records"];
            
            if (result != nil){
                for (NSDictionary * dictBike in result) {
                    BikeModel * bike =  [[BikeModel alloc] initWithDict:dictBike];
                    [_bikes addObject:bike];
                }
            }

            done(nil);
        }
      

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"download error: %@",error.localizedDescription);
        done(error);

    }];
    

}

-(NSArray*)sortedBikesWithDistance:(NSArray *)bikes{
    NSArray * myArray = [NSArray new];
    
    myArray = [bikes sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        BikeModel * bike1 = obj1;
        BikeModel * bike2 = obj2;
        return bike1.distance > bike2.distance;
    }];
    return myArray;
}

@end
