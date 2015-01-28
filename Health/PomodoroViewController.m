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

int seconds;
NSTimer* pomodoroTimer;
BOOL breakTime;
BOOL completed;
BOOL continuing;
NSString* pomodorosString;
int timePeriod;

NSUserDefaults* settings;

int workPeriodInSeconds;
int breakPeriodInSeconds;


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSettings) name:UIApplicationWillEnterForegroundNotification  object:nil];
    
    NSLog(@"==viewDidLoad==");
    
    [self setupValues];
    [self setupView];
}

- (void) setupValues {
    NSLog(@"setting values!!!");
    if (!pomodoroTimer) {
        
        // initialization
        
        settings = [NSUserDefaults standardUserDefaults];
        inputScores = [[InputScores alloc] init];
        dailyScores = [[DailyScores alloc] init];
        
        workPeriodInSeconds = 25;
        breakPeriodInSeconds = 5;
        
        seconds = 0;
    }
}

- (void) saveTimer {
    NSLog(@"test for saving Timer");
    if (pomodoroTimer) {
        
        int todaySince1970 = (int)[[NSDate date] timeIntervalSince1970];
        
        
        [settings setInteger:seconds forKey:@"PomodoroSeconds"];
        [settings setInteger:todaySince1970 forKey:@"PomodoroAwayDate"];
        [settings setBool:breakTime forKey:@"PomodoroBreakTime"];
        [settings synchronize];
    
        NSLog(@"breakTime saved is: %i", [settings boolForKey:@"PomodoroBreakTime"]);
        NSLog(@"pomodoroAwayDate is: %i", (int)[settings integerForKey:@"PomodoroAwayDate"]);
    }
}

- (void) setupSettings {
    
    [self setupValues];
    if (!settings) {
        settings = [NSUserDefaults standardUserDefaults];
        NSLog(@"made settings");
    }
    NSLog(@"setup settings");
    
    int wentawayInt = (int)[settings integerForKey:@"PomodoroAwayDate"];
    
    NSLog(@"wentawayInt = %i", wentawayInt);
    
    NSDate* wentAwayDate = [NSDate dateWithTimeIntervalSince1970:wentawayInt];
    
    NSLog(@"date is %@.", wentAwayDate);
    
    if (!!wentAwayDate) {
        NSLog(@"we found settings");
        
        continuing = YES;
        
        
        BOOL historicalBreakTime = [settings boolForKey:@"PomodoroBreakTime"];
        int historicalSeconds = (int)[settings integerForKey:@"PomodoroSeconds"];
        
        NSLog(@"breaktime gotten is %i", historicalBreakTime);
        NSLog(@"historical seconds is %i", historicalSeconds);
        NSLog(@"breakperiod is %i, workperiod is %i", breakPeriodInSeconds, workPeriodInSeconds);
        
        int intervalSinceWentAway = (int)[[NSDate date] timeIntervalSinceDate:wentAwayDate];
        int countDownInterval = intervalSinceWentAway;
        int timeLeft;
        
        NSLog(@"right now = %@. wentAway at %@.", [NSDate date], wentAwayDate);
        
        NSLog(@"countdowninterval = %i", countDownInterval);
        
        NSLog(@"historicalBreakTime is now %i", historicalBreakTime);
        
        BOOL smallTimeAway = NO;
        
        if (historicalBreakTime == YES) {
            timeLeft = breakPeriodInSeconds - historicalSeconds;
            NSLog(@"timeleft is %i", timeLeft);
            if (countDownInterval > timeLeft) {
                countDownInterval -= timeLeft;
                historicalBreakTime = NO;
            }
            else
                smallTimeAway = YES;
        }
        else if (historicalBreakTime == NO) {
            NSLog(@"historicalBreakTime == NO");
            timeLeft = workPeriodInSeconds - historicalSeconds;
            NSLog(@"timeleft is %i", timeLeft);
            if (countDownInterval > timeLeft) {
                countDownInterval -= timeLeft;
                historicalBreakTime = YES;
                
                [inputScores writeValue:[NSNumber numberWithInt:1]
                               withDate:[NSDate dateWithTimeInterval:(intervalSinceWentAway - countDownInterval)
                                                           sinceDate:wentAwayDate]
                             ofVariable:@"Pomodoros"];
                
            }
            else
                smallTimeAway = YES;
        }
        
        NSLog(@"1. historicalBreakTime is now %i", historicalBreakTime);
        
        if (smallTimeAway == NO) {
            while (countDownInterval > 0) {
                if (historicalBreakTime == YES) {
                    if (countDownInterval > breakPeriodInSeconds) {
                        countDownInterval -= breakPeriodInSeconds;
                        historicalBreakTime = NO;
                    }
                    else {
                        smallTimeAway = YES;
                        break;
                    }
                }
                else if (historicalBreakTime == NO) {
                    if (countDownInterval > workPeriodInSeconds) {
                        countDownInterval -= workPeriodInSeconds;
                        historicalBreakTime = YES;
                        
                        [inputScores writeValue:[NSNumber numberWithInt:1]
                                       withDate:[NSDate dateWithTimeInterval:(intervalSinceWentAway - countDownInterval)
                                                                   sinceDate:wentAwayDate]
                                     ofVariable:@"Pomodoros"];
                    }
                    else {
                        smallTimeAway = YES;
                        break;
                    }
                }
                NSLog(@"countDownInterval left is... %f", countDownInterval);
            }
        }
        
        NSLog(@"2. historicalBreakTime is now %i", historicalBreakTime);
        
        seconds = countDownInterval;
        breakTime = historicalBreakTime;
        if (!pomodoroTimer)
            [self startTimer];
        
        [settings removeObjectForKey:@"PomodoroAwayDate"];
        [settings removeObjectForKey:@"PomodoroBreakTime"];
        [settings removeObjectForKey:@"PomodoroSeconds"];
        [settings synchronize];
    }
    [self setupView];
    

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setupView {
    
    // Do any additional setup after loading the view.
    
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    
    self.continueButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.startButton.hidden = NO;
    
    if (continuing == NO) {
        self.timeProgress.progress = 0;
        [self startWorkState];
    }
    
    if (!pomodorosString) {
        [self.scoreLabel setAlpha:0];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            [self setTotalPomodoros];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [self.scoreLabel setText:pomodorosString]; // 3
                [UIView animateWithDuration:0.3
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

    continuing = NO;
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
        [self startTimer];
    }
    else {
        [pomodoroTimer invalidate];
        pomodoroTimer = nil;
        [self newStateOfButton:self.continueButton visible:YES];
        [self newStateOfButton:self.stopButton visible:YES];
        [self newStateOfButton:self.startButton visible:NO];
    }
}

- (void) startTimer {
    SEL updateTimer = @selector(updatePomodoroTimer);
    pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:updateTimer userInfo:nil repeats:YES];
    [self.startButton setTitle:@"PAUSE" forState:UIControlStateNormal];
}

- (IBAction)continueButtonPress:(id)sender {
    NSLog(@"continue");
    [self startTimer];
    
    [self newStateOfButton:self.continueButton visible:NO];
    [self newStateOfButton:self.stopButton visible:NO];
    [self newStateOfButton:self.startButton visible:YES];
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
        }
    }
    
    seconds += 1;
    int minutes = floor(seconds/60);
    self.minutesLabel.text = [NSString stringWithFormat:@"%i", minutes];
    [self.timeProgress setProgress:((float)seconds / timePeriod) animated:NO];
    
    //NSLog(@"seconds %i / timePeriod %i = %)
    
    if (self.timeProgress.progress == 1) {
        completed = YES;
        
        if (breakTime == NO) {
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
}

- (void) startWorkState {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:230/255.0 green:38/255.0 blue:43/255.0 alpha:1];
    timePeriod = workPeriodInSeconds;
    breakTime = NO;
}

- (void) startBreakState {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:231/255.0 green:211/255.0 blue:6/255.0 alpha:1];
    timePeriod = breakPeriodInSeconds;
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
