//
//  WDeviceViewController.m
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import "WDeviceViewController.h"
#import "WSectionHeaderView.h"
#import "WSelectEstateView.h"
#import "WEntranceTableViewCell.h"
#import <WekerIM/WekerIM.h>
#import "MJExtension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WDeviceViewController () <UITableViewDelegate, UITableViewDataSource, WSelectEstateDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WSelectEstateView *headerView;

@property (nonatomic, strong) WSectionHeaderView *sectionHeaderView;

@end

@implementation WDeviceViewController {
    int _tempCommunityId;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
    _dataArray = [NSMutableArray new];
}

- (void)createUI {
    self.title = @"设备列表";
 
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.leftBarButtonItem = logOut;
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    self.navigationItem.rightBarButtonItem = refresh;

    [self.view addSubview:self.tableView];
}

- (void)logOut {
    BOOL isSucceed = [[WClient sharedManager] logout];
    if (isSucceed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchRootViewController" object:nil];
    } else {
        NSLog(@"登出失败");
    }
}

- (void)refresh {
    [[NSNotificationCenter defaultCenter] postNotificationName:refreshNotification object:nil];
}

- (void)loadDataWithPartitionId:(NSUInteger)partitionId {
    [[WClient sharedManager] entranceListWithPartitionId:partitionId completed:^(id result) {
        self.dataArray = [Entrance mj_objectArrayWithKeyValuesArray:result];
        [self.tableView reloadData];
    }];
}

#pragma mark - dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderView.bounds.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEntranceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WEntranceTableViewCellIdentifier forIndexPath:indexPath];
    cell.entrance = self.dataArray[indexPath.row];
    return cell;
}

- (void)selectEstateViewDidSelectPartitionWithId:(NSUInteger)partitionId {
    [self loadDataWithPartitionId:partitionId];
}

- (void)selectEstateViewDidLoadDefaultPartitionWithId:(NSUInteger)partitionId {
    [self loadDataWithPartitionId:partitionId];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerNib:[UINib nibWithNibName:WEntranceTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:WEntranceTableViewCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (WSelectEstateView *)headerView {
    if (!_headerView) {
        _headerView = [[WSelectEstateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 234)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (WSectionHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[WSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47) title:@"门禁列表"];
    }
    return _sectionHeaderView;
}

@end
