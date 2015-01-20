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
    PListFunctions* plist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    plist = [[PListFunctions alloc] init];
}

- (IBAction)happinessButtonPress:(id)sender {
    
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.day = -1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* yesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    [plist writeDailyValue:[NSNumber numberWithFloat:4.32] withDate:yesterday ofVariable:@"Happiness"];
    
    date = [NSDate date];
    comps = [[NSDateComponents alloc]init];
    comps.day = -2;
    calendar = [NSCalendar currentCalendar];
    NSDate* dayBeforeYesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    

    [plist writeDailyValue:[NSNumber numberWithInt:4.56] withDate:dayBeforeYesterday ofVariable:@"Happiness"];
    
}


@end
