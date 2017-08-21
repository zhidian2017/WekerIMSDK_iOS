//
//  WViewController.m
//  WekerCloudIM
//
//  Created by huahua0809 on 05/15/2017.
//  Copyright (c) 2017 huahua0809. All rights reserved.
//

#import "WViewController.h"
#import <WekerIM/WekerIM.h>

@interface WViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


- (IBAction)loginAction;


@end

@implementation WViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userName.text = @"15958143182";
    self.password.text = @"123456";
}

- (IBAction)loginAction {
    
    if (!self.userName.text || !self.password.text) return;
    [[WClient sharedManager] loginWithUserName:self.userName.text password:self.password.text completion:^(NSString *aUsername, BOOL aError) {
        if (!aError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchRootViewController" object:nil];
        }
    }];
    
    
}

@end
