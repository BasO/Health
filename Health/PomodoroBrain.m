//
//  PomodoroBrain.m
//  Health
//
//  Created by Bas Oppenheim on 28-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
//  Contains the mechanics behind the Pomodoro-timer, e.g. a timer. 

#import "PomodoroBrain.h"

@implementation PomodoroBrain

int workPeriodInSeconds;
int breakPeriodInSeconds;
int minutes;

InputScores* inputScores;
DailyScores* dailyScores;

NSUserDefaults* settings;

NSTimer* pomodoroTimer;

@synthesize seconds = _seconds;
@synthesize breaktime = _breaktime;
@synthesize totalPomodoros = _totalPomodoros;
@synthesize timerIsOn = _timerIsOn;
@synthesize timePeriod;

- (id)init {
    self = [super init];
    
    // setup local variables
    if (self) {
        settings = [NSUserDefaults standardUserDefaults];
        inputScores = [[InputScores alloc] init];
        dailyScores = [[DailyScores alloc] init];
        
        minutes = 60;
        
        workPeriodInSeconds = 25 * minutes;
        breakPeriodInSeconds = 5 * minutes;
        
        // continue last session if possible
        if (![self checkForSuspendedTimer])
        {
            self.seconds = 0;
            [self startWorkPeriod];
        }
    }
    return self;
}

# pragma mark - control timer;

- (void) startTimer {
    if (!pomodoroTimer) {
        SEL updateTimer = @selector(updatePomodoroTimer);
        pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:updateTimer userInfo:nil repeats:YES];
        self.timerIsOn = YES;
    }
}

- (void) stopTimer {
    [pomodoroTimer invalidate];
    pomodoroTimer = nil;
    self.timerIsOn = NO;
}

- (void) resetTimer {
    self.seconds = 0;
    self.breaktime = NO;
    [self.delegate updateMinutesTo:0];
}

# pragma mark - pomodoro progress functions

// Count valid seconds in timePeriod
- (void) updatePomodoroTimer
{
    self.seconds += 1;
    
    // switch work/break-period
    if (self.seconds == self.timePeriod) {
        if (self.breaktime == NO) {
            [self writeScore];
            [self.delegate updatePomodorosTo:self.totalPomodoros];
            
            [self startBreakPeriod];
        }
        else {
            [self startWorkPeriod];
        }
        self.seconds = 0;
    }
    
    // update minutes & progress bar shown in PomodoroViewController
    if (self.seconds % minutes == 0) {
        [self.delegate updateMinutesTo: (self.seconds / minutes) ];
    }
    [self.delegate updateProgressTo:(self.seconds / (float)self.timePeriod)];
}

// Setup the Brain & View for work-period.
- (void) startWorkPeriod {
    self.timePeriod = workPeriodInSeconds;
    self.breaktime = NO;
    [self.delegate setupWorkPeriodView];
}

// Setup the Brain & View for break-period.
- (void) startBreakPeriod {
    self.timePeriod = breakPeriodInSeconds;
    self.breaktime = YES;
    [self.delegate setupBreakPeriodView];
}

# pragma mark - timer suspension

// Save values of session-properties
- (void) suspendTimer {
    int todaySince1970 = (int)[[NSDate date] timeIntervalSince1970];
    
    [settings setInteger:self.seconds forKey:@"PomodoroSeconds"];
    [settings setInteger:todaySince1970 forKey:@"PomodoroAwayDate"];
    [settings setBool:self.breaktime forKey:@"PomodoroBreakTime"];
    [settings setBool:self.timerIsOn forKey:@"PomodoroTimerIsOn"];
    [settings synchronize];
}

# pragma mark - timer session continuation

// Return 1 if a saved session can be retrieved
- (BOOL) checkForSuspendedTimer {
    if ([settings integerForKey:@"PomodoroAwayDate"]) {
        [self continueTimer];
        return 1;
    }
    else {
        return 0;
    }
}

// Restore session, taking the time difference in account
- (void) continueTimer {
    
    // load values of past session
    int wentawayInt = (int)[settings integerForKey:@"PomodoroAwayDate"];
    BOOL historicalBreaktime = [settings boolForKey:@"PomodoroBreakTime"];
    int historicalSeconds = (int)[settings integerForKey:@"PomodoroSeconds"];
    
    BOOL historicalTimerIsOn = [settings boolForKey:@"PomodoroTimerIsOn"];
    
    if (historicalTimerIsOn == NO) {
        self.seconds = historicalSeconds;
        self.breaktime = historicalBreaktime;
    }
    else {
        // calculate seconds between past session and now
        NSDate* wentAwayDate = [NSDate dateWithTimeIntervalSince1970:wentawayInt];
        int intervalSinceWentAway = (int)[[NSDate date] timeIntervalSinceDate:wentAwayDate];
        int countDownInterval = intervalSinceWentAway + historicalSeconds;
        
        // save pomodoros gained in the mean time, determine if new period is
        // workPeriod or breakPeriod, calculate the number of seconds into this period
        while (countDownInterval > 0) {
            if (historicalBreaktime == YES) {
                if (countDownInterval > breakPeriodInSeconds) {
                    countDownInterval -= breakPeriodInSeconds;
                    historicalBreaktime = NO;
                }
                else
                    break;
            }
            else if (historicalBreaktime == NO) {
                if (countDownInterval > workPeriodInSeconds) {
                    countDownInterval -= workPeriodInSeconds;
                    historicalBreaktime = YES;
                    
                    [inputScores writeValue:[NSNumber numberWithInt:1]
                                   withDate:[NSDate dateWithTimeInterval:(intervalSinceWentAway - countDownInterval)
                                                               sinceDate:wentAwayDate]
                                 ofVariable:@"Pomodoros"];
                }
                else
                    break;
            }
        }
        self.seconds = countDownInterval;
        self.breaktime = historicalBreaktime;
    }
    
    if (self.breaktime == NO) {
        [self startWorkPeriod];
    }
    else {
        [self startBreakPeriod];
    }

    if (historicalTimerIsOn == YES) {
        [self startTimer];
    }
    
    // remove past session's data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [settings removeObjectForKey:@"PomodoroAwayDate"];
        [settings removeObjectForKey:@"PomodoroBreakTime"];
        [settings removeObjectForKey:@"PomodoroSeconds"];
        [settings removeObjectForKey:@"PomodoroTimerIsOn"];
        [settings synchronize];
    });
}

# pragma mark - save score

// Save each gained pomodoro in InputScores, get & save total pomodoros in DailyScores
- (void) writeScore {
    [inputScores writeValue:[NSNumber numberWithInt:1]
                   withDate:[NSDate date]
                 ofVariable:@"Pomodoros"];
    
    NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Pomodoros"];
    
    [dailyScores writeValue:totalScore
                   withDate:[NSDate date]
                 ofVariable:@"Pomodoros"];
    
    self.totalPomodoros = [totalScore intValue];
}

# pragma mark - getters

- (int) totalPomodoros {
    if (!_totalPomodoros) {
        NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                                  forVariable:@"Pomodoros"];
        _totalPomodoros = [totalScore intValue];
    }
    return _totalPomodoros;
}


@end
