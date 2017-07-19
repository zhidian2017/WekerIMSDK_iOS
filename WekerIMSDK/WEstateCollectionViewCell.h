//
//  WEstateCollectionViewCell.h
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const WEstateCollectionViewCellIdentifier;

@interface WEstate : NSObject

@property (nonatomic, copy) NSString *communityName;

@property (nonatomic, assign) int communityId;

@property (nonatomic, assign) BOOL isSelected;

@end

@interface WEstateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) WEstate *estate;

@end
