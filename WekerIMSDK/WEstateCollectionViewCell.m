//
//  WEstateCollectionViewCell.m
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import "WEstateCollectionViewCell.h"

NSString *const WEstateCollectionViewCellIdentifier = @"WEstateCollectionViewCell";


@interface WEstate ()

@end

@implementation WEstate

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"communityId":@"id"};
}

@end

@interface WEstateCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WEstateCollectionViewCell

- (void)setEstate:(WEstate *)estate {
    _estate = estate;
    
    self.titleLabel.text = estate.communityName;
    
    self.titleLabel.textColor = estate.isSelected ? [UIColor whiteColor] : [UIColor blackColor];
    self.contentView.backgroundColor = estate.isSelected ? [UIColor lightGrayColor] : [UIColor whiteColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
}


@end
