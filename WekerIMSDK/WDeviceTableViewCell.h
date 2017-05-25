//
//  WDeviceTableViewCell.h
//  WekerCloudIM
//
//  Created by 黄珂耀 on 2017/5/15.
//  Copyright © 2017年 huahua0809. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Entrance;

extern NSString *const WDeviceTableViewCellIdentifier;

@interface WDeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *blockNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *unlockButton;

@property (nonatomic, strong) Entrance *entrance;

@end
