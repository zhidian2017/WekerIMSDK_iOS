//
//  WDevicesTableViewController.m
//  WekerCloudIM
//
//  Created by 黄珂耀 on 2017/5/15.
//  Copyright © 2017年 huahua0809. All rights reserved.
//

#import "WDevicesTableViewController.h"
#import "WDeviceTableViewCell.h"
#import <WekerIM/WekerIM.h>
#import "MJExtension.h"

@interface WDevicesTableViewController ()<WClientDelegate>

@property (nonatomic, strong) NSArray *estateArray;

@property (nonatomic, strong) NSMutableArray *entranceArray;

@property (nonatomic, strong) Entrance *selectedEntrance;

@end

@implementation WDevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WClient sharedManager].delegate = self;
    
//    [WClient sharedManager].options.isAvoidDisturb = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:WDeviceTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:WDeviceTableViewCellIdentifier];
    self.title = @"设备列表";
    
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.leftBarButtonItem = logOut;
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadEstateData)];
    
    self.navigationItem.rightBarButtonItem = refresh;
    
    [self loadEstateData];
}

- (void)logOut {
    BOOL isSucceed = [[WClient sharedManager] logout];
    if (isSucceed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchRootViewController" object:nil];
    } else {
        NSLog(@"登出失败");
    }
}

- (void)loadEstateData {
    self.entranceArray = [NSMutableArray new];
    [[WClient sharedManager] communityListWithCompleted:^(id result) {
        self.estateArray = [Estate mj_objectArrayWithKeyValuesArray:result];
        [self.estateArray enumerateObjectsUsingBlock:^(Estate *estate, NSUInteger idx, BOOL * _Nonnull stop) {
            [self loadEntranceDataWithCommunityId:estate.communityId];
        }];
    }];
}

- (void)loadEntranceDataWithCommunityId:(int)communityId {
    [[WClient sharedManager] entranceListWithCommunityId:communityId completed:^(id result) {
        NSArray *entrances = [Entrance mj_objectArrayWithKeyValuesArray:result];
        [self.entranceArray addObject:entrances];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.estateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.entranceArray.count > 0) {
        NSArray *entrances = self.entranceArray[section];
        return entrances.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *communityLabel = [UILabel new];
    communityLabel.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 40);
    Estate *estate = self.estateArray[section];
    communityLabel.text = estate.communityName;
    communityLabel.textAlignment = NSTextAlignmentCenter;
    communityLabel.backgroundColor = [UIColor lightGrayColor];
    return communityLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *entrances = self.entranceArray[indexPath.section];
    Entrance *entrance = entrances[indexPath.row];
    WDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WDeviceTableViewCellIdentifier forIndexPath:indexPath];
    cell.entrance = entrance;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.blockNameLabel.text = entrance.blockName;
    
    return cell;
}

-(void)userAccountDidLoginFromOtherDevice {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchRootViewController" object:nil];
}

-(void)dealloc {
    [WClient sharedManager].delegate = nil;
}

@end
