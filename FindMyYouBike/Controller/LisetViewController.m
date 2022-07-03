//
//  LisetViewController.m
//  FindMyYouBike
//
//  Created by TSENGWENJIAN on 2017/10/6.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "LisetViewController.h"
#import "BikeLocationManager.h"
#import "ListTableViewCell.h"



@interface LisetViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    
    NSMutableArray<BikeModel*> * searchBikes;
    BikeLocationManager * bikesManager;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTop;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation LisetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    if(searchBikes == nil){
        searchBikes = [NSMutableArray new];
    }
    
    if(bikesManager == nil){
        bikesManager = [BikeLocationManager shared];
    }
    
    
}



-(NSMutableArray*)getCollectionBikes{
    
    NSMutableArray* collectionBikes = [NSMutableArray new];
    for(NSString * ID in bikesManager.collectionIDs){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID == %@",ID];
        [collectionBikes addObjectsFromArray:[bikesManager.bikes filteredArrayUsingPredicate:predicate]];
    };
    
    return [[NSMutableArray alloc] initWithArray:[bikesManager sortedBikesWithDistance:collectionBikes]];
    
    
}
- (IBAction)changeList:(UISegmentedControl*)sender {
    
    
    if(sender.selectedSegmentIndex == 0){
        
        [_searchBar resignFirstResponder];
        [_searchBar setShowsCancelButton:false animated:false];
        _searchBar.text = nil;
        searchBikes = [self getCollectionBikes];
        
    }else{
        searchBikes = bikesManager.bikes;
        
    }
    [_listTableView reloadData];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self->_searchBarTop.constant = sender.selectedSegmentIndex == 0 ? -50:0;
        [self.view layoutIfNeeded];
        
    } completion:nil];
    
}



-(void)refreshBikesData{
    searchBikes = _mySegment.selectedSegmentIndex == 0 ?[self getCollectionBikes]:bikesManager.bikes;
    [_listTableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTableView{
    [self refreshBikesData];
}

- (void)changeIsCollected:(UIButton *)sender{
    CGPoint point = [sender convertPoint:CGPointZero toView:_listTableView];
    NSIndexPath *indexPath = [_listTableView indexPathForRowAtPoint:point];
    BikeModel * bike = searchBikes[indexPath.row];
    
    if(bike.isCollected){
        
        NSInteger  index = [bikesManager.collectionIDs indexOfObject:bike.ID];
        [[BikeLocationManager shared].collectionIDs removeObjectAtIndex:index];
        
        [sender setSelected:false];
        bike.isCollected = false;
        
    }else{
        
        [[BikeLocationManager shared].collectionIDs addObject:bike.ID];
        [sender setSelected:true];
        bike.isCollected = true;
        
    }
    
    [bikesManager setCollectionIDs:bikesManager.collectionIDs];
    
    if(_mySegment.selectedSegmentIndex == 0){
        
        [searchBikes removeObject:bike];
        [_listTableView reloadData];
    }else{
        [_listTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

#pragma UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = searchBikes[indexPath.row].sna;
    cell.sbiLabel.text = [NSString stringWithFormat:@"可借 %@",searchBikes[indexPath.row].sbi];
    cell.bempLabel.text = searchBikes[indexPath.row].bemp;
    cell.addressLabel.text = searchBikes[indexPath.row].ar;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f km",searchBikes[indexPath.row].distance];
    cell.updateTime.text = searchBikes[indexPath.row].updateTime;
    [cell.collectionButton setSelected:searchBikes[indexPath.row].isCollected];
    [cell.collectionButton addTarget:self action:@selector(changeIsCollected:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectItemDone(searchBikes[indexPath.row]);
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return searchBikes.count;
}

#pragma mark UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:true animated:true];
    return  true;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    [searchBar setShowsCancelButton:false animated:true];
    [self refreshBikesData];
    [searchBar resignFirstResponder];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sna CONTAINS %@ OR ar CONTAINS %@",searchBar.text,searchBar.text];
    searchBikes = [[NSMutableArray alloc] initWithArray:[bikesManager.bikes filteredArrayUsingPredicate:predicate]];
    [_listTableView reloadData];
    [searchBar resignFirstResponder];
}


@end
