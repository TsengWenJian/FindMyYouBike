//
//  DetailViewController.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "DetailViewController.h"
#import "BikeLocationManager.h"
#import <MapKit/MapKit.h>




@interface DetailViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerLabelViews;

@end

@implementation DetailViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.view layer ] setShadowOffset:CGSizeMake(1, 1)];
    [[self.view layer]setShadowColor:[UIColor blackColor].CGColor];
    
    
    for (UIView * containView in _containerLabelViews){
        [containView layer].cornerRadius = 5;
    }
    
}
-(void) updateUbikeStatus{
     
    if(_bike == nil){
      
        return;
       
    }
    _titleLabel.text = _bike.sna;
    _totLabel.text = [NSString stringWithFormat:@"可借 %@",_bike.sbi];
    _bempLabel.text = _bike.bemp;
    _distanceLabel.text =[NSString stringWithFormat:@"%.1f km",_bike.distance];
    _addressLabel.text = _bike.ar;
    _updateTimeLabel.text = _bike.updateTime;
    [_isCollectionBtn setSelected:_bike.isCollected];
    
}

- (IBAction)showOtherFuc:(UIButton*)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"導航" message:@"請選擇" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * google = [UIAlertAction actionWithTitle:@"開啟 Google Maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL * url;
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&directionsmode=walking",_bike.lat,_bike.lon]];
            
        }else{
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.google.com/?daddr=%f,%f&directionsmode=walking",_bike.lat,_bike.lon]];
        }
        
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if(success) NSLog(@"open goolemaps success");
        }];
        
    }];
    UIAlertAction * apple = [UIAlertAction actionWithTitle:@"開啟 地圖導航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        CLLocationCoordinate2D targetCoord = CLLocationCoordinate2DMake(_bike.lat, _bike.lon);
        MKPlacemark *targetPlace = [[MKPlacemark alloc] initWithCoordinate:targetCoord];
        MKMapItem * targetMapItem = [[MKMapItem alloc] initWithPlacemark:targetPlace];
        [targetMapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
        
        
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:google];
    [alert addAction:apple];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:true completion:nil];
    
}


- (IBAction)changeCollection:(UIButton*)sender {
    
    
    if(_bike.isCollected){
        NSInteger  index = [[BikeLocationManager shared].collectionIDs indexOfObject:_bike.ID];
        [[BikeLocationManager shared].collectionIDs removeObjectAtIndex:index];
        [_isCollectionBtn setSelected:false];
        _bike.isCollected = false;
        
    }else{
        
        [[BikeLocationManager shared].collectionIDs addObject:_bike.ID];
        [_isCollectionBtn setSelected:true];
        _bike.isCollected = true;
        
    }
    
    [[BikeLocationManager shared] setCollectionIDs:[BikeLocationManager shared].collectionIDs];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
