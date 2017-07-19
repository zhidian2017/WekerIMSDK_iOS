//
//  WEntranceTableViewCell.h
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WekerIM/WekerIM.h>

extern NSString *const WEntranceTableViewCellIdentifier;

@interface WEntrance : NSObject

@property (nonatomic, copy) NSString *blockName;

@property (nonatomic, assign) int entranceId;

@property (nonatomic, strong) WDeviceEasemob *deviceEasemob;

@end

@interface WEntranceTableViewCell : UITableViewCell

@property (nonatomic, strong) WEntrance *entrance;

@end
