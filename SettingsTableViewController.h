//
//  SettingsTableViewController.h
//  Pomodoro Timer
//
//  Created by ivan on 16/12/1.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *cellData;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *userDefaultsKey;
@end
