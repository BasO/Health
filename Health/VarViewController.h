//
//  VarViewController.h
//  Health
//
//  Created by Bas Oppenheim on 11-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppVar.h"
#import "BEMSimpleLineGraphView.h"
#import "PListFunctions.h"

@interface VarViewController : UITableViewController <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (nonatomic) NSMutableArray* inputKeys;
@property (nonatomic) NSMutableArray* dailyKeys;

@property (strong, nonatomic) NSString* variable;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *varTitle;
@property (weak, nonatomic) IBOutlet UILabel *lastRatingLabel;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graph;

@end
