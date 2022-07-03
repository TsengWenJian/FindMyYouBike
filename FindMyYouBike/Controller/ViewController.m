//
//  ViewController.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BikeLocationManager.h"
#import "DetailViewController.h"
#import "CustomAnnotationView.h"
#import "CustomPointAnnotation.h"
#import "ProfileTableViewController.h"
#import "LisetViewController.h"
#import <SVProgressHUD.h>
#import "Reachability.h"


@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager * clManager;
    NSMutableArray * bikes;
    BikeLocationManager * bikesManager;
    DetailViewController *detailVC;
    LisetViewController *listVC;
    ProfileTableViewController * profileVC ;
    BOOL isShowListView;
    BOOL isShowProfileView;
    BOOL isShowDetailView;
    Reachability *youBikesReach;
    NSLock *refreshLock;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailContainerTop;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *detailContainer;
@property (weak, nonatomic) IBOutlet UIView *listContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listContainerViewLeading;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    clManager = [CLLocationManager new];
    bikesManager = [BikeLocationManager shared];
    youBikesReach = [Reachability reachabilityWithHostName:YOUBIKE_URL];
    
    CGFloat detailHeight = -(self.view.frame.size.height*0.2)-10;
    
    _detailContainerTop.constant = detailHeight < -130 ?detailHeight:-130;
    _listContainerViewLeading.constant = -self.view.frame.size.width-10;
    
    
    
    [_detailContainer.layer setShadowOffset:CGSizeMake(1,1)] ;
    [_detailContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [_detailContainer.layer setShadowOpacity:0.3];
    
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:false];
    
    if([clManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        
        [clManager requestWhenInUseAuthorization];
        
    }
    [clManager startUpdatingLocation];
    
    [self setNavigationItem];
    [self setChildsVC];
    [self refreshBikesData];
    [clManager setDistanceFilter:(100)];
    [clManager setDelegate:self];
    [clManager setActivityType:CLActivityTypeAutomotiveNavigation];
    [clManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    

}


-(void)setNavigationItem{
    
    UIBarButtonItem *location = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                             target:self action:@selector(refreshBikesData)];
    
    self.navigationItem.rightBarButtonItems = @[location,refresh] ;
    
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self  action:@selector(showListVC)];
    self.navigationItem.leftBarButtonItem = listItem;
    
    
}

-(void) setChildsVC{
    for(UIViewController  *VC in [self childViewControllers]){
        
        if([VC isKindOfClass:[DetailViewController class]]){
            detailVC = (DetailViewController*)VC;
        }
        
        if([VC isKindOfClass:[LisetViewController class]]){
            listVC = (LisetViewController*)VC;
        }
    }
    
    profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTableViewController"];
}

- (IBAction)showProfileVC:(id)sender {
    CGAffineTransform  myTransform ;
    
    if (isShowProfileView){
        
        [profileVC hiddeProfileVC];
        myTransform = CGAffineTransformIdentity;
        
    }else{
        [profileVC showProfileVC:self];
        __weak ViewController *weakSelf = self;
        profileVC.selectMapTypeDone = ^(NSInteger index) {
            MKMapType type;
            switch (index) {
                case 0:
                    type = MKMapTypeStandard;
                    
                    break;
                case 1:
                    type = MKMapTypeSatellite;
                    break;
                    
                default:
                    type = MKMapTypeHybrid;
                    break;
            }
            
            [weakSelf.mapView setMapType:type];
        };
        
        myTransform = CGAffineTransformMakeRotation(180 * M_PI/180);
        
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self->_arrowImage.transform = myTransform;
    } completion:nil];
    
    isShowProfileView = !isShowProfileView;
    
}
-(void)showListVC{
    CGFloat leading = 0;
    
    if(isShowListView){
        leading = -self.view.bounds.size.width-10;
        isShowListView = false;
        [detailVC updateUbikeStatus];
        [self.view endEditing:true];
        
    }else{
        
        isShowListView = true;
        [listVC updateTableView];
        
        __weak ViewController *weakSelf = self;
        listVC.selectItemDone = ^(BikeModel *reslut) {
            [weakSelf showListVC];
            if(reslut != nil){
                
                NSArray * annotations =  [weakSelf.mapView annotations];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",reslut.sna];
                NSArray* fileResult = [[NSMutableArray alloc] initWithArray:[annotations filteredArrayUsingPredicate:predicate]];
                [weakSelf.mapView selectAnnotation:fileResult.firstObject animated:true];
                
            }
        };
    }
    [self moveContainerView: _listContainerViewLeading target:leading];
    
}

-(void)refreshBikesData{
    
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    if (youBikesReach == nil || [youBikesReach currentReachabilityStatus] == 0){
        
        [SVProgressHUD showErrorWithStatus:@"無法取的網際網路"];
        [SVProgressHUD dismissWithDelay:0.8];
        return;
        
    }

    [SVProgressHUD show];
   

    [_mapView removeAnnotations:_mapView.annotations];

    [bikesManager getAllBikeLocation:^(NSError *error) {
         
         [SVProgressHUD dismiss];
       
        
        
            if (error == nil){
        
                [self calculateDistance:[self->clManager location]];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self addBikesLocationOnMap];
                if(self->isShowListView)[listVC updateTableView];
                if(self->isShowDetailView)[detailVC updateUbikeStatus];
            });
        }
    }];
    
}

-(void)calculateDistance:(CLLocation*)userLoctaion{
    
    if(userLoctaion == nil){
        return;
    }
    
    
    
    for (BikeModel * bike in  bikesManager.bikes) {
       
        if(bike == nil){
            return;
        }
        
        CLLocation  *target = [[CLLocation alloc] initWithLatitude:bike.lat longitude:bike.lon];
        bike.distance = [userLoctaion distanceFromLocation:target]/1000;
        
    }
    
    bikesManager.bikes =  [[NSMutableArray alloc] initWithArray:[bikesManager sortedBikesWithDistance:bikesManager.bikes]];
    bikes = bikesManager.bikes;
   
    
}




-(void)moveContainerView:(NSLayoutConstraint*)layout target:(CGFloat)value{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        layout.constant = value;
          [self.view layoutIfNeeded];
    } completion:nil];
    
}

-(void)addBikesLocationOnMap{
    
    for (BikeModel * myBike in bikes) {
        
        CLLocationCoordinate2D coord;
        coord.latitude = myBike.lat;
        coord.longitude = myBike.lon;
        CustomPointAnnotation * point = [CustomPointAnnotation new];
        point.coordinate = coord;
        point.title = myBike.sna;
        point.bike = myBike;
        [_mapView addAnnotation:point];
        
    }
    
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if((!isShowDetailView || isShowListView)&& bikesManager.bikes.count != 0 ){
        
        [self calculateDistance:locations.firstObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self->isShowDetailView)[self->detailVC updateUbikeStatus];
        });
        
       
    }
}
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    
     [self moveContainerView: _detailContainerTop target:-_detailContainer.frame.size.height-10];
     CGAffineTransform transform_4 = CGAffineTransformIdentity;
     view.transform = transform_4;
     isShowDetailView = false;
    
    
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if([view isKindOfClass:[CustomAnnotationView class]]){
        
    BikeModel * myBike = [(CustomAnnotationView*)view bike];
    CGAffineTransform transform_4 = CGAffineTransformScale(view.transform,1.3,1.3);
    view.transform = transform_4;
    isShowDetailView = true;
     [self moveContainerView: _detailContainerTop target:10];
    
    detailVC.bike = myBike;
    [detailVC updateUbikeStatus];
    
    CLLocationCoordinate2D  coord = CLLocationCoordinate2DMake(myBike.lat, myBike.lon);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    
    [_mapView setRegion:region animated:true];
    
     }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    if ([annotation isKindOfClass:[CustomPointAnnotation class]]){
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        CustomAnnotationView * annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        BikeModel * myBike = [(CustomPointAnnotation *)annotation bike];
        
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.bike = myBike;
        
        
        
        if ([myBike.sbi isEqualToString:@"0"] || ![myBike.act isEqualToString:@"1"]){
            
            [annotationView setLayerColor:[UIColor redColor]];
            annotationView.sbiLabel.text = ![myBike.act isEqualToString:@"1"] ?@"X":myBike.sbi;
            
            
        }else{
            UIColor * background = [UIColor colorWithRed:10/255.f green:200/255.f blue:220/255.f alpha:1];
            [annotationView setLayerColor:background];
            annotationView.sbiLabel.text = myBike.sbi;
        }
        
        
        return annotationView;
        
    }
    
    return nil;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

