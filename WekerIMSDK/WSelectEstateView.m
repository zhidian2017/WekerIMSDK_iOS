//
//  WSelectEstateView.m
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import "WSelectEstateView.h"
#import "WSectionHeaderView.h"
#import "WEstateCollectionViewCell.h"
#import <WekerIM/WekerIM.h>
#import "MJExtension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

NSString *const refreshNotification = @"refreshNotification";

@interface WSelectEstateView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) WSectionHeaderView *selectCommunityHeaderView;

@property (nonatomic, strong) WSectionHeaderView *selectPartitionHeaderView;

@property (nonatomic, strong) UICollectionView *communityCollectionView;

@property (nonatomic, strong) UICollectionView *partitionCollectionView;

@property (nonatomic, strong) CALayer *separator;

@property (nonatomic, strong) NSMutableArray *communityArray;

@property (nonatomic, strong) NSMutableArray *partitionArray;

@end

@implementation WSelectEstateView {
    NSIndexPath *_tempIndexPath;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:refreshNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommunityData) name:refreshNotification object:nil];
        
        [self createUI];
        
        _communityArray = [NSMutableArray new];
        _partitionArray = [NSMutableArray new];
        
        [self loadCommunityData];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.selectCommunityHeaderView];
    [self addSubview:self.communityCollectionView];;
    [self addSubview:self.selectPartitionHeaderView];
    [self addSubview:self.partitionCollectionView];
    [self.layer addSublayer:self.separator];
}

- (void)loadCommunityData {
    [[WClient sharedManager] communityPartitionListWithCompleted:^(id result) {
        self.communityArray = [Estate mj_objectArrayWithKeyValuesArray:result];
        [self.communityCollectionView reloadData];
        if (self.communityArray.count > 0) {
            [self loadPartitionDataWithEstate:self.communityArray[0]];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.communityCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }];
}

- (void)loadPartitionDataWithEstate:(Estate *)estate {
    self.partitionArray = [Partition mj_objectArrayWithKeyValuesArray:estate.partitionList];
    [self.partitionCollectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.partitionCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectEstateViewDidLoadDefaultPartitionWithId:)]) {
        Partition *partition = [Partition mj_objectWithKeyValues:estate.partitionList[0]];
        [self.delegate selectEstateViewDidLoadDefaultPartitionWithId:partition.partitionId];
    }

}

#pragma mark - dataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.communityCollectionView) {
        return self.communityArray.count;
    } else {
        return self.partitionArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEstateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WEstateCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (collectionView == self.communityCollectionView) {
        Estate *estate = self.communityArray[indexPath.row];
        cell.title = estate.communityName;
    } else {
        Partition *partition = self.partitionArray[indexPath.row];
        cell.title = partition.partitionName;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.communityCollectionView) {
        [self loadPartitionDataWithEstate:self.communityArray[indexPath.row]];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectEstateViewDidSelectPartitionWithId:)]) {
            Partition *partition = self.partitionArray[indexPath.row];
            [self.delegate selectEstateViewDidSelectPartitionWithId:partition.partitionId];
        }
    }
}

#pragma mark - getter
- (WSectionHeaderView *)selectCommunityHeaderView {
    if (!_selectCommunityHeaderView) {
        _selectCommunityHeaderView = [[WSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47) title:@"选择小区"];
    }
    return _selectCommunityHeaderView;
}

- (WSectionHeaderView *)selectPartitionHeaderView {
    if (!_selectPartitionHeaderView) {
        _selectPartitionHeaderView = [[WSectionHeaderView alloc] initWithFrame:CGRectMake(0, 112, kScreenWidth, 47) title:@"选择分区"];
    }
    return _selectPartitionHeaderView;
}

- (UICollectionView *)communityCollectionView {
    if (!_communityCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(100, 65);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _communityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.selectCommunityHeaderView.bounds.size.height, kScreenWidth, 65) collectionViewLayout:flowLayout];
        _communityCollectionView.dataSource = self;
        _communityCollectionView.delegate = self;
        _communityCollectionView.backgroundColor = [UIColor whiteColor];
        _communityCollectionView.showsHorizontalScrollIndicator = NO;
        _communityCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_communityCollectionView registerNib:[UINib nibWithNibName:WEstateCollectionViewCellIdentifier bundle:nil] forCellWithReuseIdentifier:WEstateCollectionViewCellIdentifier];
    }
    return _communityCollectionView;
}

- (UICollectionView *)partitionCollectionView {
    if (!_partitionCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(100, 65);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _partitionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.selectPartitionHeaderView.bounds.size.height * 2 + self.communityCollectionView.bounds.size.height, kScreenWidth, 65) collectionViewLayout:flowLayout];
        _partitionCollectionView.dataSource = self;
        _partitionCollectionView.delegate = self;
        _partitionCollectionView.backgroundColor = [UIColor whiteColor];
        _partitionCollectionView.showsHorizontalScrollIndicator = NO;
        _partitionCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_partitionCollectionView registerNib:[UINib nibWithNibName:WEstateCollectionViewCellIdentifier bundle:nil] forCellWithReuseIdentifier:WEstateCollectionViewCellIdentifier];
    }
    return _partitionCollectionView;
}

- (CALayer *)separator {
    if (!_separator) {
        _separator = [CALayer layer];
        _separator.backgroundColor = [UIColor lightGrayColor].CGColor;
        _separator.frame = CGRectMake(0, self.bounds.size.height - 5, self.bounds.size.width, 5);
    }
    return _separator;
}

@end
