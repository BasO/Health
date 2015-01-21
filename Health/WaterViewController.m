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
    int totalWaterIntake;
    InputScores* inputScores;
    DailyScores* dailyScores;
}
@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    inputScores = [[InputScores alloc] init];
    dailyScores = [[DailyScores alloc] init];
    
    NSNumber* dailyTotal = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Water"];
    
    self.drinkLabel.text = [NSString stringWithFormat:@"%@", dailyTotal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)drinkButtonPress:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    NSString* input = resultButton.currentTitle;
    
    int buttonValue;
    if ([input compare:@"Drink 33 mL"] == NSOrderedSame)
        buttonValue = 33;
    else if ([input compare:@"Drink 50 mL"] == NSOrderedSame)
        buttonValue = 50;
}
 */

- (IBAction)ml33ButtonPress:(id)sender {
    
    [inputScores writeValue:[NSNumber numberWithInt:33]
                   withDate:[NSDate date]
                 ofVariable:@"Water"];
    
    NSNumber* dailyTotal = [inputScores totalValueForDate:[NSDate date]
                                        forVariable:@"Water"];
    
    [dailyScores writeValue:dailyTotal
                   withDate:[NSDate date]
                 ofVariable:@"Water"];
    
    self.drinkLabel.text = [NSString stringWithFormat:@"%@", dailyTotal];
    
}

- (IBAction)ml50ButtonPress:(id)sender {
    
    [inputScores writeValue:[NSNumber numberWithInt:50]
                   withDate:[NSDate date]
                 ofVariable:@"Water"];
    
    NSNumber* dailyTotal = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Water"];
    
    [dailyScores writeValue:dailyTotal
                   withDate:[NSDate date]
                 ofVariable:@"Water"];
    
    self.drinkLabel.text = [NSString stringWithFormat:@"%@", dailyTotal];
}

- (IBAction)undoButtonPress:(id)sender {
}

@end