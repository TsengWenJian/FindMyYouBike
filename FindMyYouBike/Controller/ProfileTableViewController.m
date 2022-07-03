//
//  ProfileTableViewController.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/8.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "MapTypeTableViewCell.h"
#import <MessageUI/MessageUI.h>


@interface ProfileTableViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>{
    NSArray * items;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileTableViewTop;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    items = @[@"地圖類型",@"聯絡我們",@"給予評價",@"本程式非官方軟體，內容僅供查詢參考，所有資訊皆以「YouBike桃園市公共自行車」官網為主"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showProfileVC:(UIViewController*)parent{
    [parent addChildViewController:self];
    [parent.view addSubview:self.view];
    self.shadowView.alpha = 0;
    _profileTableViewTop.constant = - self.view.bounds.size.height;
     [self.view layoutIfNeeded];

    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self->_profileTableViewTop.constant = 0;
        self.shadowView.alpha = 0.65;
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self didMoveToParentViewController:parent];
    
}
-(void)hiddeProfileVC{
    [self didMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return items.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        MapTypeTableViewCell * mapTypeCell = [tableView dequeueReusableCellWithIdentifier:@"MapTypeTableViewCell"];
        mapTypeCell.titleLabel.text = items[indexPath.row];
        [mapTypeCell.mapTypeSegment addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
        return mapTypeCell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
    cell.textLabel.text = items[indexPath.row];
    
    
    
    if(indexPath.row == 3){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}


-(void)changeMapType:(UISegmentedControl*)sender{
    NSInteger index = sender.selectedSegmentIndex;
    _selectMapTypeDone(index);

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
       
        if([MFMailComposeViewController canSendMail ]){
          MFMailComposeViewController * email = [MFMailComposeViewController new];
            [email setMailComposeDelegate:self];
            [email setSubject:@"App問題回報"];
            [email setToRecipients:@[@"tsengwenjian@gmail.com"]];
            [email setMessageBody:@"iPhone機型：\niOS:版本號：\n回報問題：" isHTML:false];
            
            [self presentViewController:email animated:true completion:nil];
        }
    }else if (indexPath.row == 2){
        
       
        NSURL * url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1294378675"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
            if(success){
                NSLog(@"go to AppStore success");
            }
        }];
    }
    
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}



@end
