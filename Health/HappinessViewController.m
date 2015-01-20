//
//  HappinessViewController.m
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "HappinessViewController.h"

@interface HappinessViewController ()

@end

@implementation HappinessViewController
{
    PListFunctions* plist;
}

NSDateFormatter* timeFormat;

@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    plist = [[PListFunctions alloc] init];
    
    // somehow have to do this for the position of timeLabel to work
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    self.timeLabel.text = [timeFormat stringFromDate:[NSDate date]];
    
    self.timeLabel.hidden = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)feelingsButtonPressed:(id)sender {
    [self showTimeForButton:sender];
    
    UIButton *resultButton = (UIButton *)sender;
    NSString* input = resultButton.currentTitle;
    
    int buttonValue;
    if ([input compare:@"😄"] == NSOrderedSame)
        buttonValue = 5;
    else if ([input compare:@"😊"] == NSOrderedSame)
        buttonValue = 4;
    else if ([input compare:@"😐"] == NSOrderedSame)
        buttonValue = 3;
    else if ([input compare:@"😞"] == NSOrderedSame)
        buttonValue = 2;
    else if ([input compare:@"😪"] == NSOrderedSame)
        buttonValue = 1;
    
    [plist writeInputValue:[NSNumber numberWithInt:buttonValue]
                  withDate:[NSDate date]
                ofVariable:@"Happiness"];
    
    [self writeDailyScoreToPList:buttonValue];
    
}


- (void)showTimeForButton:(UIButton*)button
{
    // show current time in timeLabel
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    self.timeLabel.text = [timeFormat stringFromDate:[NSDate date]];
    
    // set correct position of timeLabel
    [self.timeLabel setCenter:CGPointMake(button.frame.origin.x - 30, button.center.y)];
//    NSLog(@"button y is %f", button.center.y);
    
    self.timeLabel.hidden = NO;
    self.timeLabel.alpha = 1;
    
    // animate timeLabel
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.timeLabel.alpha = 0;
//                         NSLog(@"2 y is %f", self.timeLabel.frame.origin.y);
                         self.timeLabel.center = CGPointMake(self.view.frame.origin.x + 50, button.center.y);
                         
                     }
                     completion:^(BOOL finished) {
                         if (self.timeLabel.alpha <= 0.1)
                             self.timeLabel.hidden = YES;
                     }];

}


- (void) writeDailyScoreToPList:(int)value
{
    float dailyScoreTotal = 0;
    float dailyScoreNumber = 0;
    
    NSMutableDictionary* happinessInputDict = [plist variableInputDict:@"Happiness"];
    
    for (id key in happinessInputDict) {
        NSDictionary* saveKey = [happinessInputDict objectForKey:key];
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
            dailyScoreNumber += 1;
        
        }
        else
            break;
    }
    
    float dailyAverage = (dailyScoreTotal / dailyScoreNumber);
    
    [plist writeDailyValue:[NSNumber numberWithFloat:dailyAverage]
                  withDate:[NSDate date]
                ofVariable:@"Happiness"];
}

@end
