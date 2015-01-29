//
//  LogViewController.h
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
//  ViewController showing a (selectable) list of all variables with data.

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import "DailyScores.h"

@interface LogViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
