//
//  HappinessViewController.h
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"
#import "InputScores.h"
#import "DailyScores.h"

@interface HappinessViewController : UIViewController <MSPageViewControllerChild>

@property (weak, nonatomic) IBOutlet UIButton *bestButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *neutralButton;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *worstButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
