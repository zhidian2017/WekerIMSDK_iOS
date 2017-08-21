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

@interface WEntranceTableViewCell : UITableViewCell

@property (nonatomic, strong) Entrance *entrance;

@end
