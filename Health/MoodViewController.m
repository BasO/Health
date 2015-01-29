//
//  MoodViewController.m
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "MoodViewController.h"

@interface MoodViewController ()

@end

@implementation MoodViewController
{
    InputScores* inputScores;
    DailyScores* dailyScores;
    NSDateFormatter* timeFormat;
    NSArray* scoreButtons;
}

@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    inputScores = [[InputScores alloc] init];
    dailyScores = [[DailyScores alloc] init];
    
    scoreButtons = [[NSArray alloc] initWithObjects:self.bestButton, self.goodButton, self.neutralButton, self.badButton, self.worstButton, nil];
    
    [self.scoreViewSegmentedControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"MoodScoreView"]];
    
    [self setupButtons];
    [self updateButtons];
}

- (void) setupButtons {
    
    [self.bestButton setupWithValue:5
                   andEmoticonTitle:@"😄"
                     andNumberTitle:@"5"
                      andLabelTitle:@"Great"];
    [self.goodButton setupWithValue:4
                   andEmoticonTitle:@"😊"
                     andNumberTitle:@"4"
                      andLabelTitle:@"Good"];
    [self.neutralButton setupWithValue:3
                   andEmoticonTitle:@"😐"
                     andNumberTitle:@"3"
                      andLabelTitle:@"OK"];
    [self.badButton setupWithValue:2
                   andEmoticonTitle:@"😞"
                     andNumberTitle:@"3"
                      andLabelTitle:@"OK"];
    [self.worstButton setupWithValue:1
                   andEmoticonTitle:@"😪"
                     andNumberTitle:@"1"
                      andLabelTitle:@"Worst"];
}

- (void) updateButtons {
    for (MoodScoreButton* button in scoreButtons) {
        if (self.scoreViewSegmentedControl.selectedSegmentIndex == 0)
            [button setTitle:button.buttonEmoticon forState:UIControlStateNormal];
        else if (self.scoreViewSegmentedControl.selectedSegmentIndex == 1)
            [button setTitle:button.buttonNumber forState:UIControlStateNormal];
        else if (self.scoreViewSegmentedControl.selectedSegmentIndex == 2)
            [button setTitle:button.buttonLabel forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)feelingsButtonPressed:(id)sender {
    [self showTimeForButton:sender];
    [self writeValue:[sender buttonValue]];
}

- (void) writeValue:(int)value {
    [inputScores writeValue:[NSNumber numberWithInt:value]
                   withDate:[NSDate date]
                 ofVariable:@"Mood"];
    
    NSNumber* averageScore = [inputScores averageValueForDate:[NSDate date]
                                                  forVariable:@"Mood"];
    
    [dailyScores writeValue:averageScore
                   withDate:[NSDate date]
                 ofVariable:@"Mood"];
}


- (void)showTimeForButton:(UIButton*)button
{
    // show current time in timeLabel
    MoodTimeLabel *timeLabel = [[MoodTimeLabel alloc] initWithFrame:CGRectMake(button.frame.origin.x - 30, button.center.y, 75, 35)];
    
    
    
    [timeLabel setCenter:CGPointMake(button.frame.origin.x, button.center.y)];
    [self.view addSubview:timeLabel];
    [self.view sendSubviewToBack:timeLabel];
    
    [timeLabel showTime];
    
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         timeLabel.frame = CGRectMake(self.view.frame.origin.x + 30, timeLabel.frame.origin.y, 75, 35);
                         
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                               delay:0
                                             options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              timeLabel.frame = CGRectMake(self.view.frame.origin.x - 100, timeLabel.frame.origin.y, 75, 35);
                                              timeLabel.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              [timeLabel removeFromSuperview];
                                          }];
                     }];
}

- (IBAction)scoreViewSegmentedControlChange:(id)sender {
    [self updateButtons];
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.scoreViewSegmentedControl.selectedSegmentIndex forKey:@"MoodScoreView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
