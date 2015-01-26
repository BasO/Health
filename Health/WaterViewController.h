//
//  WaterViewController.h
//  Health
//
//  Created by Bas Oppenheim on 20-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"
#import "InputScores.h"
#import "DailyScores.h"

@interface WaterViewController : UIViewController <MSPageViewControllerChild, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *waterContentPicker;
@property (weak, nonatomic) IBOutlet UIProgressView *waterIntakeProgress;

@property (weak, nonatomic) IBOutlet UILabel *drinkLabel;

@property (weak, nonatomic) IBOutlet UIButton *ml33Button;

@property (weak, nonatomic) IBOutlet UIButton *ml50Button;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UIStepper *goalStepper;
@property (weak, nonatomic) IBOutlet UIProgressView *secondaryWaterIntakeProgress;


@end