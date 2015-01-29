//
//  WaterViewController.h
//  Health
//
//  Created by Bas Oppenheim on 20-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
//  ViewController in which the user can record their daily water intake and set a goal amount.
//  Progress is visually represented.

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"
#import "InputScores.h"
#import "DailyScores.h"

@interface WaterViewController : UIViewController <MSPageViewControllerChild, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *waterContentPicker;
@property (weak, nonatomic) IBOutlet UIProgressView *waterIntakeProgress;

@property (weak, nonatomic) IBOutlet UIButton *drinkButton;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UIStepper *goalStepper;
@property (weak, nonatomic) IBOutlet UIProgressView *secondaryWaterIntakeProgress;


@end