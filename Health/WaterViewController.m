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
    
    // initialize local variables
    inputScores = [[InputScores alloc] init];
    dailyScores = [[DailyScores alloc] init];
    settings = [NSUserDefaults standardUserDefaults];
    
    targetWaterIntake = [settings floatForKey:@"dailyWaterTarget"];
    
    NSNumber* dailyTotal = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Water"];
    dailyWaterIntake = [dailyTotal floatValue];
    targetComplete = (dailyWaterIntake >= targetWaterIntake);
    
    pickerData = [[NSArray alloc] initWithObjects:@15, @20, @25, @30, @33, @35, @40, @45, @50, @75, @100, @150, @200, nil];
    
    // update view
    [self configureView];
}

- (void) viewDidAppear:(BOOL)animated {
    // picker always defaults to last picked index
    [self.waterContentPicker selectRow:[settings integerForKey:@"waterContentIndex"] inComponent:0 animated:YES];
}

- (void) configureView {
    self.goalStepper.value = targetWaterIntake;
    self.goalLabel.text = [NSString stringWithFormat:@"%.1f", targetWaterIntake];
    self.secondaryWaterIntakeProgress.hidden = YES;
    self.secondaryWaterIntakeProgress.alpha = 0;
    
    [self updateProgress];
}

# pragma mark - drink progress functions

// Save drink quantity in the picker, update drinking progress bar
- (IBAction)drinkButtonPress:(id)sender {
    [self writeScore];
    [self updateProgress];
}

// Change & save target amount of water, update drinking progress bar
- (IBAction)goalStepperPress:(id)sender {
    NSLog(@"GSP - %f", self.goalStepper.value);
    targetWaterIntake = self.goalStepper.value;
    
    [self.goalLabel setText:[NSString stringWithFormat:@"%.1f", self.goalStepper.value]];
    [self updateProgress];
    
    [settings setFloat:targetWaterIntake forKey:@"dailyWaterTarget"];
    [settings synchronize];
}

// Update water intake progress bar based on current & goal amount of water
- (void) updateProgress {
    // first progress bar = current / total
    float progress = (dailyWaterIntake / (targetWaterIntake * 1000));
    [self.waterIntakeProgress setProgress:progress];

    // second progress bar = (current - total) / total
    float progressBeyondTarget = (dailyWaterIntake - (targetWaterIntake * 1000)) / (targetWaterIntake * 1000);
    [self.secondaryWaterIntakeProgress setProgress:progressBeyondTarget];
}

# pragma mark - picker setup

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ cL", pickerData[row]];
}

# pragma mark - save score

// save picker index, save chosen value, update daily amount of water
- (void) writeScore {
    // save picker index as a preference
    int waterContentPickerIndex = (int)[self.waterContentPicker selectedRowInComponent:0];
    [settings setInteger:waterContentPickerIndex forKey:@"waterContentIndex"];
    [settings synchronize];
    
    // save picker value, in milli-liter instead of centi-liter
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end