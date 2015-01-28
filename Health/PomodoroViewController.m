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

NSString* pomodorosString;
PomodoroBrain* pomodoroBrain;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self.startButton setHidden:NO];
    [self.continueButton setHidden:YES];
    [self.stopButton setHidden:YES];
    [self.timeProgress setProgress:0];
    
    [self showStartupState];
    
    pomodoroBrain = [[PomodoroBrain alloc] init];
    pomodoroBrain.delegate = self;
    
    [pomodoroBrain startWorkState];
    [pomodoroBrain updateView];
    
    [[NSNotificationCenter defaultCenter] addObserver:pomodoroBrain selector:@selector(suspendTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:pomodoroBrain selector:@selector(checkForSuspendedTimer) name:UIApplicationWillEnterForegroundNotification  object:nil];
}

- (IBAction)timerButton:(id)sender {
    if (![pomodoroBrain timerIsOn]) {
        [pomodoroBrain startTimer];
        [self showWorkingState];
    }
    else {
        [pomodoroBrain stopTimer];
        [self showPauseState];
    }
}

- (void) showPauseState {
    [self newStateOfButton:self.startButton visible:NO];
    [self newStateOfButton:self.continueButton visible:YES];
    [self newStateOfButton:self.stopButton visible:YES];
}

- (void) showStartupState {
    [self newStateOfButton:self.startButton visible:YES];
    [self newStateOfButton:self.continueButton visible:NO];
    [self newStateOfButton:self.stopButton visible:NO];
    
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self setupWorkView];
}

- (void) showWorkingState {
    [self newStateOfButton:self.startButton visible:YES];
    [self newStateOfButton:self.continueButton visible:NO];
    [self newStateOfButton:self.stopButton visible:NO];
    
    [self.startButton setTitle:@"PAUSE" forState:UIControlStateNormal];
}

- (IBAction)continueButtonPress:(id)sender {
    [pomodoroBrain startTimer];
    [self showWorkingState];
}

- (IBAction)stopButtonPress:(id)sender {
    [pomodoroBrain resetTimer];
    [self showResettingOfTimer];
    [self showStartupState];
}

- (void) showResettingOfTimer {
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
}

- (void) newStateOfButton:(id)button visible:(BOOL)visible  {
    
    [button setUserInteractionEnabled:visible];
    if (visible) {
        [button setAlpha:0];
        [button setHidden:NO];
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         [button setAlpha:visible];
                     }
                     completion:^(BOOL finished) {
                         [button setHidden:!visible];
                     }];
}



- (void) setupWorkView {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:230/255.0 green:38/255.0 blue:43/255.0 alpha:1];
}

- (void) setupBreakView {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:231/255.0 green:211/255.0 blue:6/255.0 alpha:1];
}

- (void) updateMinutesTo:(int)minutes {
    self.minutesLabel.text = [NSString stringWithFormat:@"%i", minutes];
}

- (void)updatePomodorosTo:(int)pomodoros {
    
    if (pomodoros == 0) {
        // Give the user a short explanation of the pomodoro system
        self.scoreLabel.text = @"25 minutes work\n5 minutes break\nRepeat";
    }
    else {
        NSMutableString* pomodoroScoreString = [[NSMutableString alloc] initWithFormat:@""];
        for (int i = 0; i < pomodoros; i++) {
            [pomodoroScoreString appendString:@"⭐️"];
        }
        self.scoreLabel.text = pomodoroScoreString;
    }
}

- (void)updateProgressTo:(float)progress {
    [self.timeProgress setProgress:progress];
    NSLog(@"%f", progress);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:pomodoroBrain];
}

@end