//
//  WEstateCollectionViewCell.m
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import "WEstateCollectionViewCell.h"

NSString *const WEstateCollectionViewCellIdentifier = @"WEstateCollectionViewCell";

@interface WEstateCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WEstateCollectionViewCell

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
}


@end
