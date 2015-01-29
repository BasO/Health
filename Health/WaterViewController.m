//
//  WaterViewController.m
//  Health
//
//  Created by Bas Oppenheim on 20-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterViewController.h"

@interface WaterViewController ()

@end

@implementation WaterViewController{
    float dailyWaterIntake;
    InputScores* inputScores;
    DailyScores* dailyScores;
    NSArray* pickerData;
    float targetWaterIntake;
    NSUserDefaults *settings;
    BOOL targetComplete;
}
@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    inputScores = [[InputScores alloc] init];
    dailyScores = [[DailyScores alloc] init];
    
    settings = [NSUserDefaults standardUserDefaults];
    
    targetWaterIntake = [settings floatForKey:@"dailyWaterTarget"];
    
    self.goalStepper.value = targetWaterIntake;
    self.goalLabel.text = [NSString stringWithFormat:@"%.1f", targetWaterIntake];
    self.secondaryWaterIntakeProgress.hidden = YES;
    self.secondaryWaterIntakeProgress.alpha = 0;
    self.secondaryWaterIntakeProgress.progress = 0;
    
    self.waterIntakeProgress.progress = 0;
    
    self.waterIntakeProgress.tintColor = [UIColor colorWithRed:184/255.0 green:232/255.0 blue:241/255.0 alpha:1];
    self.secondaryWaterIntakeProgress.tintColor = self.waterIntakeProgress.tintColor;
    
    
    NSNumber* dailyTotal = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Water"];
    dailyWaterIntake = [dailyTotal floatValue];
    
    [self updateProgress];
    
    self.drinkLabel.text = [NSString stringWithFormat:@"%@", dailyTotal];
    
    pickerData = [[NSArray alloc] initWithObjects:@15, @20, @25, @30, @33, @35, @40, @45, @50, @75, @100, @150, @200, nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.waterContentPicker selectRow:[settings integerForKey:@"waterContentIndex"] inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ml33ButtonPress:(id)sender {
    
    int waterContentPickerIndex = (int)[self.waterContentPicker selectedRowInComponent:0];
    
    
    float saveValue = [[pickerData objectAtIndex:waterContentPickerIndex] floatValue] * 10;
    
    [inputScores writeValue:[NSNumber numberWithInt:saveValue]
                   withDate:[NSDate date]
                 ofVariable:@"Water"];
    
    NSNumber* dailyTotal = [inputScores totalValueForDate:[NSDate date]
                                        forVariable:@"Water"];
    
    [dailyScores writeValue:dailyTotal
                   withDate:[NSDate date]
                 ofVariable:@"Water"];
    
    dailyWaterIntake = [dailyTotal floatValue];
    
    [self updateProgress];
    
    [settings setInteger:waterContentPickerIndex forKey:@"waterContentIndex"];
    
    
}

- (void) updateProgress {
    
    if (!targetComplete) {
        float progress = (dailyWaterIntake / (targetWaterIntake * 1000));
        [self.waterIntakeProgress setProgress:progress];
        if (progress >= 1)
            targetComplete = YES;
    }
    if (targetComplete) {
        float progress = ((dailyWaterIntake - (targetWaterIntake * 1000)) / ((targetWaterIntake * 1000) * 2));
        [self.secondaryWaterIntakeProgress setProgress:progress];
        if (progress < 0) {
            targetComplete = NO;
            [self updateProgress];
        }
    }
}

- (IBAction)goalStepperPress:(id)sender {
    NSLog(@"GSP - %f", self.goalStepper.value);
    targetWaterIntake = self.goalStepper.value;
    
    [self.goalLabel setText:[NSString stringWithFormat:@"%.1f", self.goalStepper.value]];
    [self updateProgress];
    
    [settings setFloat:targetWaterIntake forKey:@"dailyWaterTarget"];
    [settings synchronize];
}


- (IBAction)undoButtonPress:(id)sender {
}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@ cL", pickerData[row]];
}

     

@end