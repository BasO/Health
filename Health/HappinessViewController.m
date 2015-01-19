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

NSDateFormatter* timeFormat;

@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self writeScoreToPList:buttonValue];
    
}


- (void)showTimeForButton:(UIButton*)button
{
    // show current time in timeLabel
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    self.timeLabel.text = [timeFormat stringFromDate:[NSDate date]];
    
    // set correct position of timeLabel
    [self.timeLabel setCenter:CGPointMake(button.frame.origin.x - 30, button.center.y)];
    NSLog(@"button y is %f", button.center.y);
    
    self.timeLabel.hidden = NO;
    self.timeLabel.alpha = 1;
    
    // animate timeLabel
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.timeLabel.alpha = 0;
                         NSLog(@"2 y is %f", self.timeLabel.frame.origin.y);
                         self.timeLabel.center = CGPointMake(self.view.frame.origin.x + 50, button.center.y);
                         
                     }
                     completion:^(BOOL finished) {
                         if (self.timeLabel.alpha <= 0.1)
                             self.timeLabel.hidden = YES;
                     }];

}

-(NSString *)getFilePath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"HappinessScores.plist"];
}

-(void) writeScoreToPList:(int)value
{
    int happinessDataPoints = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"happinessDataPoints"];
    
    NSString* saveKey = [NSString stringWithFormat:@"%.8d", happinessDataPoints];
    
    [[NSUserDefaults standardUserDefaults] setInteger:(happinessDataPoints + 1) forKey:@"happinessDataPoints"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"HappinessScores.plist"];
    NSMutableDictionary *newDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path]mutableCopy];
    
    NSMutableDictionary* happinessDict = [[NSMutableDictionary alloc] initWithDictionary:[newDict objectForKey:@"Happiness"]];
    
    NSMutableDictionary* subDict = [[NSMutableDictionary alloc] init];
    
    [subDict setValue:[NSNumber numberWithInt:value] forKey:@"value"];
    [subDict setValue:[NSDate date] forKey:@"time"];
    
    //
    
    [happinessDict setValue:subDict forKey:[NSString stringWithString:saveKey]];
    
    NSLog(@"%@", happinessDict);
    
    [newDict setValue:happinessDict forKey:@"Happiness"];
    
    
    NSLog(@"WROTE TO PLIST? %i", [newDict writeToFile:path atomically:YES]);
    
    NSLog(@"PLIST DICT IS %@", newDict);

    
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}




@end
