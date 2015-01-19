//
//  ImportViewController.h
//  Health
//
//  Created by Bas Oppenheim on 19-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@interface ImportViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;

@property (weak, nonatomic) IBOutlet UIView *stepsButton;
@property (weak, nonatomic) IBOutlet UIView *sleepButton;



@end
