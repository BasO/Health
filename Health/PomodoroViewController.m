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
    
    // initialise local variables
    pomodoroBrain = [[PomodoroBrain alloc] init];
    pomodoroBrain.delegate = self;
    
    // add observers for app backgrounding and foregrounding
    [[NSNotificationCenter defaultCenter] addObserver:pomodoroBrain selector:@selector(suspendTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreSession) name:UIApplicationWillEnterForegroundNotification  object:nil];
    
    // setup view
    [self showStartupStateWithFade:NO];
    [self updateView];
}

- (void) updateView {
    [self updateMinutesTo:(pomodoroBrain.seconds / 60)];
    [self updatePomodorosTo:pomodoroBrain.totalPomodoros];
    [self updateProgressTo:(pomodoroBrain.seconds / (float)pomodoroBrain.timePeriod)];
}

- (void) restoreSession {
    if ([pomodoroBrain checkForSuspendedTimer]) {
        [self updateView];
    }
}

# pragma mark - Timer buttons

- (IBAction)startButtonPress:(id)sender {
    if (![pomodoroBrain timerIsOn]) {
        [pomodoroBrain startTimer];
        [self showTimingState];
    }
    else {
        [pomodoroBrain stopTimer];
        [self showPauseState];
    }
}

- (IBAction)continueButtonPress:(id)sender {
    [pomodoroBrain startTimer];
    [self showTimingState];
}

- (IBAction)stopButtonPress:(id)sender {
    [pomodoroBrain resetTimer];
    [self showResettingOfTimer];
    [self showStartupStateWithFade:YES];
}

# pragma mark - update UI based on timer state

- (void) showStartupStateWithFade:(BOOL)fade {
    if (fade == NO) {
        [self.startButton setHidden:NO];
        [self.continueButton setHidden:YES];
        [self.stopButton setHidden:YES];
    }
    else if (fade == YES) {
        [self newStateOfButton:self.startButton visible:YES];
        [self newStateOfButton:self.continueButton visible:NO];
        [self newStateOfButton:self.stopButton visible:NO];
    }
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self setupWorkPeriodView];
}

- (void) showTimingState {
    [self newStateOfButton:self.startButton visible:YES];
    [self newStateOfButton:self.continueButton visible:NO];
    [self newStateOfButton:self.stopButton visible:NO];
    
    [self.startButton setTitle:@"PAUSE" forState:UIControlStateNormal];
}

- (void) showPauseState {
    [self newStateOfButton:self.startButton visible:NO];
    [self newStateOfButton:self.continueButton visible:YES];
    [self newStateOfButton:self.stopButton visible:YES];
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
                     completion:nil ];
}

# pragma mark - update UI based on pomodoro period

- (void) setupWorkPeriodView {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:230/255.0 green:38/255.0 blue:43/255.0 alpha:1];
}

- (void) setupBreakPeriodView {
    self.timeProgress.progressTintColor = [UIColor colorWithRed:231/255.0 green:211/255.0 blue:6/255.0 alpha:1];
}

# pragma mark - update UI based on progress in pomodoro period

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

# pragma mark - fade animation

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

# pragma mark - others

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:pomodoroBrain];
}

@end