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

@property (nonatomic, strong) WSectionHeaderView *headerView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CALayer *separator;

@property (nonatomic, strong) NSMutableArray *dataArray;

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:refreshNotification object:nil];
        
        [self createUI];
        
        [self loadData];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.headerView];
    [self addSubview:self.collectionView];
    [self.layer addSublayer:self.separator];
}

- (void)loadData {
    _dataArray = [NSMutableArray new];
    [[WClient sharedManager] communityListWithCompleted:^(id result) {
        self.dataArray = [WEstate mj_objectArrayWithKeyValuesArray:result];
        WEstate *defaultEstate = self.dataArray[_tempIndexPath ? _tempIndexPath.row: 0];
        defaultEstate.isSelected = YES;
        [self.collectionView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectEstateViewDidLoadDefaultEstateWithId:)]) {
            [self.delegate selectEstateViewDidLoadDefaultEstateWithId:defaultEstate.communityId];
        }
    }];
}

#pragma mark - dataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEstateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WEstateCollectionViewCellIdentifier forIndexPath:indexPath];
    
    WEstate *estate = self.dataArray[indexPath.row];
    
    // cell已被点击之后才做判断，否则按照初始的数据操作
    if (_tempIndexPath != nil) {
        if (_tempIndexPath == indexPath) {
            estate.isSelected = YES;
        } else {
            estate.isSelected = NO;
        }
    }
    
    cell.estate = estate;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _tempIndexPath = indexPath;
    [collectionView reloadData];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectEstateViewDidSelectEstateWithId:)]) {
        WEstate *estate = self.dataArray[indexPath.row];
        [self.delegate selectEstateViewDidSelectEstateWithId:estate.communityId];
    }
}

#pragma mark - getter
- (WSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WSectionHeaderView alloc] initWithTitle:@"选择小区"];
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(100, 65);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height, kScreenWidth, 65) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_collectionView registerNib:[UINib nibWithNibName:WEstateCollectionViewCellIdentifier bundle:nil] forCellWithReuseIdentifier:WEstateCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (CALayer *)separator {
    if (!_separator) {
        _separator = [CALayer layer];
        _separator.backgroundColor = [UIColor lightGrayColor].CGColor;
        _separator.frame = CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10);
    }
    return _separator;
}

@end
