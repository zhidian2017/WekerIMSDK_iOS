//
//  WDeviceTableViewCell.m
//  WekerCloudIM
//
//  Created by 黄珂耀 on 2017/5/15.
//  Copyright © 2017年 huahua0809. All rights reserved.
//

#import "WDeviceTableViewCell.h"
#import <WekerIM/WekerIM.h>

NSString *const WDeviceTableViewCellIdentifier = @"WDeviceTableViewCell";

@implementation WDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)unlockAction:(id)sender {
    [[WClient sharedManager] openDoorWithEntrance:self.entrance completed:^(BOOL isSucceed) {
        if (isSucceed) {
            
        } else {
            
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
