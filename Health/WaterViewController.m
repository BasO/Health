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
    PListFunctions* plist;
    int totalWaterIntake;
}
@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    plist = [[PListFunctions alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ml33ButtonPress:(id)sender {
    
    [plist writeInputValue:[NSNumber numberWithInt:33]
                  withDate:[NSDate date]
                ofVariable:@"Water"];
    
    [self writeDailyTotalToPList:33];
    
    self.drinkLabel.text = [NSString stringWithFormat:@"%i", totalWaterIntake];
    
}

- (IBAction)ml50ButtonPress:(id)sender {
}

- (IBAction)undoButtonPress:(id)sender {
}

- (void) writeDailyTotalToPList:(int)value
{
    int dailyScoreTotal = 0;
    
    NSMutableDictionary* waterInputDict = [plist variableInputDict:@"Water"];
    
    for (id key in waterInputDict) {
        NSDictionary* saveKey = [waterInputDict objectForKey:key];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        [gregorian setTimeZone:gmt];
        NSDateComponents *todayComps = [gregorian components: NSUIntegerMax fromDate: [NSDate date]];
        NSDateComponents *dictDateComps = [gregorian components: NSUIntegerMax fromDate: [saveKey valueForKey:@"time"]];
        
        if([todayComps day] == [dictDateComps day] &&
           [todayComps month] == [dictDateComps month] &&
           [todayComps year] == [dictDateComps year] &&
           [todayComps era] == [dictDateComps era]) {
            
            dailyScoreTotal += [[saveKey valueForKey:@"value"] intValue];
        }
        else
            break;
    }
    
    NSLog(@"%i", dailyScoreTotal);
    
    
    [plist writeDailyValue:[NSNumber numberWithInt:dailyScoreTotal]
                  withDate:[NSDate date]
                ofVariable:@"Water"];
    
    totalWaterIntake = dailyScoreTotal;
}
/*
- (int) totalWaterIntake {
    NSMutableDictionary* waterDict = [[NSMutableDictionary alloc] initWithDictionary:[plist variableDailyDict:@"Water"]];
    
    NSMutableArray* waterKeys = [waterDict allKeys];
    
    [waterKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
   // ...
}
*/

@end