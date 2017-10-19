//
//  CustomAnnotationView.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "CustomAnnotationView.h"



@implementation CustomAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if(self){
        containerView = [[UIView alloc] initWithFrame:CGRectMake(2.5, 2.5, 25, 25)];
        _sbiLabel = [[UILabel alloc] initWithFrame:containerView.bounds];
        _sbiLabel.textAlignment = NSTextAlignmentCenter;
        
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = containerView.bounds.size.width/2;
        [containerView addSubview:_sbiLabel];
        [self addSubview:containerView];
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, 30, 33);
        
        
    }
    return self;
    
}


- (void)drawRect:(CGRect)rect {
    
    
    if(ovalLayer){
        return;
    }
    
    
    UIBezierPath * ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
    

    ovalLayer = [CAShapeLayer new];
    ovalLayer.path = ovalPath.CGPath;
    [self.layer addSublayer:ovalLayer];
    
    
    UIBezierPath * trianglePath = [UIBezierPath new];
    CGFloat width = self.bounds.size.width;
    [trianglePath moveToPoint:CGPointMake(1,width-15)];
    [trianglePath addLineToPoint:CGPointMake(width/2,33)];
    [trianglePath addLineToPoint:CGPointMake(width-1, width-15)];
    [trianglePath closePath];
    
    
    triangleLayer =[CAShapeLayer new];
    
    triangleLayer.path = trianglePath.CGPath;
    [self.layer addSublayer:triangleLayer];
    [self bringSubviewToFront:containerView];
    
    
    if ([_bike.sbi isEqualToString:@"0"] || ![_bike.act isEqualToString:@"1"]){

        [self setLayerColor:[UIColor redColor]];

    }else{
        UIColor * background = [UIColor colorWithRed:10/255.f green:200/255.f blue:220/255.f alpha:1];
        [self setLayerColor:background];

    }

    
    
}




-(void)setLayerColor:(UIColor*)color{
    

        [ovalLayer setFillColor:color.CGColor];
        [triangleLayer setFillColor:color.CGColor];
    
   
    
    
    
}





@end
