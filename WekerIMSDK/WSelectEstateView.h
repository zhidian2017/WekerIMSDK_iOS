//
//  WSelectEstateView.h
//  WekerIMSDK
//
//  Created by 黄珂耀 on 2017/7/19.
//  Copyright © 2017年 hduhky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const refreshNotification;

@protocol WSelectEstateDelegate <NSObject>

- (void)selectEstateViewDidLoadDefaultPartitionWithId:(NSUInteger)partitionId;

- (void)selectEstateViewDidSelectPartitionWithId:(NSUInteger)partitionId;

@end

@interface WSelectEstateView : UIView

@property (nonatomic, weak) id delegate;

@end
