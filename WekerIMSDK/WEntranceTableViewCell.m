//
//  WEntranceTableViewCell.m
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import "WEntranceTableViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

NSString *const WEntranceTableViewCellIdentifier = @"WEntranceTableViewCell";

@interface WEntrance ()

@end

@implementation WEntrance

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"entranceId":@"id",@"idefault":@"default"};
}

@end

@interface WEntranceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) CALayer *separator;

@end

@implementation WEntranceTableViewCell

- (void)setEntrance:(WEntrance *)entrance {
    _entrance = entrance;
    self.titleLabel.text = entrance.blockName;
}

- (IBAction)unlockAction:(id)sender {
    [[WClient sharedManager] openDoorWithEntrance:(Entrance *)self.entrance completed:^(BOOL isSucceed) {
        if (isSucceed) {
            
        } else {
            
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.layer addSublayer:self.separator];
}

- (CALayer *)separator {
    if (!_separator) {
        _separator = [CALayer layer];
        _separator.backgroundColor = [UIColor lightGrayColor].CGColor;
        _separator.frame = CGRectMake(25, 44.5, kScreenWidth - 50, 0.5);
    }
    return _separator;
}

@end
