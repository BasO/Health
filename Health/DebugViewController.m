//
//  DebugViewController.m
//  Health
//
//  Created by Bas Oppenheim on 20-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "DebugViewController.h"

@interface DebugViewController ()

@end

@implementation DebugViewController
{
    DailyScores* dailyScores;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    dailyScores = [[DailyScores alloc] init];
}

- (IBAction)MoodButtonPress:(id)sender {
    
    // write average Mood-score of 4.32 for yesterday's date
    
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.day = -1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* yesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    [dailyScores writeValue:[NSNumber numberWithFloat:4.32]
                   withDate:yesterday
                 ofVariable:@"Mood"];
    
    // write average Mood-score of 4.56 for day before yesterday's date
    
    date = [NSDate date];
    comps = [[NSDateComponents alloc]init];
    comps.day = -2;
    calendar = [NSCalendar currentCalendar];
    NSDate* dayBeforeYesterday = [calendar dateByAddingComponents:comps toDate:date options:0];

    [dailyScores writeValue:[NSNumber numberWithInt:4.56]
                   withDate:dayBeforeYesterday
                 ofVariable:@"Mood"];
}


- (IBAction)pomodoroButtonPress:(id)sender {
    
    // write Pomodoro total score of 12 for yesterday's date
    
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.day = -1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* yesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    [dailyScores writeValue:[NSNumber numberWithFloat:12]
                   withDate:yesterday
                 ofVariable:@"Pomodoros"];
    
    // write average Mood-score of 2 for day before yesterday's date
    
    date = [NSDate date];
    comps = [[NSDateComponents alloc]init];
    comps.day = -2;
    calendar = [NSCalendar currentCalendar];
    NSDate* dayBeforeYesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    [dailyScores writeValue:[NSNumber numberWithInt:2]
                   withDate:dayBeforeYesterday
                 ofVariable:@"Pomodoros"];
    
    
    
}

- (IBAction)waterButtonPress:(id)sender {
    // write Water total score of 2600 for yesterday's date
    
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.day = -1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* yesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    [dailyScores writeValue:[NSNumber numberWithFloat:2600]
                   withDate:yesterday
                 ofVariable:@"Water"];
    
    // write Water total score of 2300 for day before yesterday's date
    
    date = [NSDate date];
    comps = [[NSDateComponents alloc]init];
    comps.day = -2;
    calendar = [NSCalendar currentCalendar];
    NSDate* dayBeforeYesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    [dailyScores writeValue:[NSNumber numberWithInt:2300]
                   withDate:dayBeforeYesterday
                 ofVariable:@"Water"];
}

@end
