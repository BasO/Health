//
//  VariableViewController.h
//  Health
//
//  Created by Bas Oppenheim on 11-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "DailyScores.h"

@interface VariableViewController : UITableViewController <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (nonatomic) NSMutableArray* inputKeys;
@property (nonatomic) NSMutableArray* dailyKeys;

@property (strong, nonatomic) NSString* variable;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *varTitle;
@property (weak, nonatomic) IBOutlet UILabel *lastRatingLabel;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graph;

@property (weak, nonatomic) IBOutlet UILabel *correlateLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *graphTimePeriodSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
