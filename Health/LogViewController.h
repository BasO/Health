//
//  LogViewController.h
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import "PListFunctions.h"

@interface LogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *psychoTable;
@property (nonatomic, strong) NSMutableArray *psychoVars;
@property (weak, nonatomic) IBOutlet UITableView *healthTable;
@property (nonatomic, strong) NSMutableArray *healthVars;

@end
