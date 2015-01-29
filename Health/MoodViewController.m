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
    NSArray* scoreButtons;
}

@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialise local variables
    inputScores = [[InputScores alloc] init];
    dailyScores = [[DailyScores alloc] init];
    scoreButtons = [[NSArray alloc] initWithObjects:self.bestButton, self.goodButton, self.neutralButton, self.badButton, self.worstButton, nil];
    
    // setup UIObjects
    [self setupButtons];
    [self.scoreViewSegmentedControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"MoodScoreView"]];
    
    // setup view
    [self updateButtons];
}

// Setup the scoreValue and possible titles for each MoodScoreButton.
- (void) setupButtons {
    self.bestButton.scoreValue = 5;
    self.bestButton.emoticonTitle = @"😄";
    self.bestButton.numberTitle = @"5";
    self.bestButton.labelTitle = @"Great";
    
    self.goodButton.scoreValue = 4;
    self.goodButton.emoticonTitle = @"😊";
    self.goodButton.numberTitle = @"4";
    self.goodButton.labelTitle = @"Good";
    
    self.neutralButton.scoreValue = 3;
    self.neutralButton.emoticonTitle = @"😐";
    self.neutralButton.numberTitle = @"3";
    self.neutralButton.labelTitle = @"OK";
    
    self.badButton.scoreValue = 2;
    self.badButton.emoticonTitle = @"😞";
    self.badButton.numberTitle = @"2";
    self.badButton.labelTitle = @"Bad";
    
    self.worstButton.scoreValue = 1;
    self.worstButton.emoticonTitle = @"😪";
    self.worstButton.numberTitle = @"1";
    self.worstButton.labelTitle = @"Worst";
}

// Set the buttontitles according to SegmentedControl's preference, save this preference.
- (IBAction)scoreViewSegmentedControlChange:(id)sender {
    [self updateButtons];
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.scoreViewSegmentedControl.selectedSegmentIndex forKey:@"MoodScoreView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Update MoodScoreButtons' titles according to scoreViewSegmentedControl's selected segment.
- (void) updateButtons {
    for (MoodScoreButton* button in scoreButtons) {
        if (self.scoreViewSegmentedControl.selectedSegmentIndex == 0)
            [button setTitle:button.emoticonTitle forState:UIControlStateNormal];
        else if (self.scoreViewSegmentedControl.selectedSegmentIndex == 1)
            [button setTitle:button.numberTitle forState:UIControlStateNormal];
        else if (self.scoreViewSegmentedControl.selectedSegmentIndex == 2)
            [button setTitle:button.labelTitle forState:UIControlStateNormal];
    }
}

// Save the pressed button's value and show its associated time.
- (IBAction)feelingsButtonPressed:(id)sender {
    [self writeValue:[sender scoreValue]];
    [self showTimeForButton:sender];
}

// Show the animation of a time (hh:mm) label flying out of a button, out of the screen.
- (void)showTimeForButton:(UIButton*)button
{
    MoodTimeLabel *timeLabel = [[MoodTimeLabel alloc] initWithFrame:CGRectMake(button.frame.origin.x - 30, button.center.y, 75, 35)];
    [timeLabel setCenter:CGPointMake(button.frame.origin.x, button.center.y)];
    [self.view addSubview:timeLabel];
    [self.view sendSubviewToBack:timeLabel];
    
    // fade in while sliding out of the button, fade out while sliding out of the screen
    [timeLabel showTime];
    [UIView animateWithDuration:1
                          delay:0
                        options:
                                 UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         timeLabel.frame = CGRectMake(self.view.frame.origin.x + 30, timeLabel.frame.origin.y, 75, 35);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                               delay:0
                                             options:
                                                      UIViewAnimationOptionAllowUserInteraction |
                                                      UIViewAnimationOptionAllowAnimatedContent |
                                                      UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              timeLabel.frame = CGRectMake(self.view.frame.origin.x - 100,
                                                                           timeLabel.frame.origin.y, 75, 35);
                                              timeLabel.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              [timeLabel removeFromSuperview];
                                          }];
                     }];
}

// Save a value in InputScores, save the daily average in DailyScores.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
