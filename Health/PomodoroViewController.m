//
//  PomodoroViewController.m
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "PomodoroViewController.h"

@interface PomodoroViewController ()

@end

@implementation PomodoroViewController
@synthesize pageIndex;

InputScores* inputScores;
DailyScores* dailyScores;

NSTimeInterval seconds;
NSTimer* pomodoroTimer;
BOOL breakTime;
BOOL completed;
BOOL counting;
NSDate* startCountingDate;
NSString* pomodorosString;
NSTimeInterval timePeriod;

NSUserDefaults* settings;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    inputScores = [[InputScores alloc] init];
    dailyScores = [[DailyScores alloc] init];
    
    settings = [NSUserDefaults standardUserDefaults];
    
    [self startWorkState];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.timeProgress setProgress:0];
    if (!seconds)
        seconds = 0;
    

    
    self.continueButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.startButton.hidden = NO;
    
    [self.scoreLabel setAlpha:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [self setTotalPomodoros];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [self.scoreLabel setText:pomodorosString]; // 3
            [UIView animateWithDuration:1
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction |
             UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 [self.scoreLabel setAlpha:1];
                             }
                             completion:^(BOOL finished) {}];
        });
    });
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTotalPomodoros {
    NSLog(@"setting total pomodoros");
    NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Pomodoros"];
    
    int totalScoreInt = [totalScore intValue];
    
    NSMutableString* pomodoroScoreString = [[NSMutableString alloc] initWithFormat:@""];
    
    for (int i = 0; i < totalScoreInt; i++) {
        [pomodoroScoreString appendString:@"⭐️"];
    }
    pomodorosString = [[NSString alloc] initWithString:pomodoroScoreString];
    
}


- (IBAction)timerButton:(id)sender {
    
    if (!pomodoroTimer) {
        SEL updateTimer = @selector(updatePomodoroTimer);
        pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:updateTimer userInfo:nil repeats:YES];
        [self.startButton setTitle:@"PAUSE" forState:UIControlStateNormal];
        [settings setObject:[NSDate date] forKey:@"startCountingDate"];
        [settings setBool:YES forKey:@"pomodoroInProgress"];
        
    }
    else {
        [pomodoroTimer invalidate];
        pomodoroTimer = nil;
        [self newStateOfButton:self.continueButton visible:YES];
        [self newStateOfButton:self.stopButton visible:YES];
        [self newStateOfButton:self.startButton visible:NO];
        [settings setBool:NO forKey:@"pomodoroInProgress"];
    }
    [settings synchronize];
}

- (IBAction)continueButtonPress:(id)sender {
    NSLog(@"continue");
    SEL updateTimer = @selector(updatePomodoroTimer);
    pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:updateTimer userInfo:nil repeats:YES];
    [self.startButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    
    [self newStateOfButton:self.continueButton visible:NO];
    [self newStateOfButton:self.stopButton visible:NO];
    [self newStateOfButton:self.startButton visible:YES];
    
    [settings setBool:YES forKey:@"pomodoroInProgress"];
}

- (IBAction)stopButtonPress:(id)sender {
    seconds = 0;
    completed = NO;
    [self startWorkState];
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationOptionAllowAnimatedContent |
     UIViewAnimationOptionBeginFromCurrentState |
     UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.timeProgress setProgress:0 animated:YES];
                     }
                     completion:^(BOOL finished) {} ];
    
    self.minutesLabel.text = @"0";
    
    [self newStateOfButton:self.stopButton visible:NO];
    [self newStateOfButton:self.continueButton visible:NO];
    [self newStateOfButton:self.startButton visible:YES];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    
    [settings setBool:NO forKey:@"pomodoroInProgress"];
}

- (void) newStateOfButton:(id)button visible:(BOOL)visible  {
    
    [button setUserInteractionEnabled:visible];
    [button setAlpha:!visible];
    if (visible)
        [button setHidden:NO];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         [button setAlpha:visible];
                     }
                     completion:^(BOOL finished) {
                         if (!visible)
                             [button setHidden:YES];
                         ;}];
}


- (void) updatePomodoroTimer
{
    if (completed) {
        seconds = 0;
        completed = NO;
        
        if (breakTime == NO) {
            // eventually start LONG worktime
            
            [self startBreakState];
        }
        else {
            [self startWorkState];
            [settings setObject:[NSDate date] forKey:@"startCountingDate"];
        }
    }
    
    seconds += 1;
    int minutes = floor(seconds/60);
    self.minutesLabel.text = [NSString stringWithFormat:@"%i", minutes];
    [self.timeProgress setProgress:(seconds / timePeriod) animated:NO];
    
    if (self.timeProgress.progress == 1) {
        completed = YES;
        
        // write new value, update look
        [inputScores writeValue:[NSNumber numberWithInt:1]
                       withDate:[NSDate date]
                     ofVariable:@"Pomodoros"];
        
        NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                                  forVariable:@"Pomodoros"];
        
        [dailyScores writeValue:totalScore
                       withDate:[NSDate date]
                     ofVariable:@"Pomodoros"];
        
        int totalScoreInt = [totalScore intValue];
        
        NSMutableString* pomodoroScoreString = [[NSMutableString alloc] initWithFormat:@""];
        
        for (int i = 0; i < totalScoreInt; i++) {
            [pomodoroScoreString appendString:@"⭐️"];
        }
        self.scoreLabel.text = pomodoroScoreString;
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction |
                                    UIViewAnimationOptionAllowAnimatedContent |
                                    UIViewAnimationOptionBeginFromCurrentState |
                                    UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.timeProgress setProgress:0 animated:YES];
                         }
                         completion:^(BOOL finished) {} ];
    }
}

- (void) startWorkState {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:230/255.0 green:38/255.0 blue:43/255.0 alpha:1];
    timePeriod = 23 * 60;
    breakTime = NO;
}

- (void) startBreakState {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:231/255.0 green:211/255.0 blue:6/255.0 alpha:1];
    timePeriod = 5 * 60;
    breakTime = YES;
}

- (void) startLongBreakState {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:231/255.0 green:199/255.0 blue:19/255.0 alpha:1];
    timePeriod = 15 * 60;
    breakTime = YES;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"YESS!");
}

/*
 
 [pomodoroTimer invalidate];
 pomodoroTimer = nil;
 seconds = 0;
            [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.startButton setUserInteractionEnabled:YES];
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
