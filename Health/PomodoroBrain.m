//
//  PomodoroBrain.m
//  Health
//
//  Created by Bas Oppenheim on 28-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "PomodoroBrain.h"

@implementation PomodoroBrain

int workPeriodInSeconds;
int breakPeriodInSeconds;
int minutes;

InputScores* inputScores;
DailyScores* dailyScores;

int timePeriod;
int totalPomodoros;

NSUserDefaults* settings;

NSTimer* pomodoroTimer;

@synthesize seconds = _seconds;
@synthesize breaktime = _breaktime;

@synthesize timerIsOn = _timerIsOn;


- (id)init {
    
    self = [super init];
    
    if (self) {
        settings = [NSUserDefaults standardUserDefaults];
        inputScores = [[InputScores alloc] init];
        dailyScores = [[DailyScores alloc] init];
        
        minutes = 60;
        
        workPeriodInSeconds = 25 * minutes;
        breakPeriodInSeconds = 5 * minutes;
        
        self.seconds = 0;
        totalPomodoros = 0;
        
        NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                                  forVariable:@"Pomodoros"];
        totalPomodoros = [totalScore intValue];
        
        NSLog(@"set up");
    }
    
    return self;
    
}

- (void) updateView {
    [self.delegate updateMinutesTo:(self.seconds / minutes)];
    [self.delegate updatePomodorosTo:totalPomodoros];
    [self.delegate updateProgressTo:(self.seconds / (float)timePeriod)];
}

- (int) totalPomodoros {
    if (!totalPomodoros) {
        NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Pomodoros"];
        totalPomodoros = [totalScore intValue];
    }
    return totalPomodoros;
}

- (void) resetTotalPomodoros {
    NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Pomodoros"];
    totalPomodoros = [totalScore intValue];
}


/// GET SECONDS, BREAKTIME, AND WRITE GAINED POMODOROS




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

# pragma mark - timer functions

- (void) updatePomodoroTimer
{
    self.seconds += 1;
    
    if (self.seconds == timePeriod) {
        if (self.breaktime == NO) {
            [self writeScore];
            [self resetTotalPomodoros];
            [self.delegate updatePomodorosTo:totalPomodoros];
            
            [self startBreakState];
        }
        else {
            [self startWorkState];
        }
        self.seconds = 0;
    }
    
    if (self.seconds % minutes == 0) {
        [self.delegate updateMinutesTo: (self.seconds / minutes) ];
    }
    
    [self.delegate updateProgressTo:(self.seconds / (float)timePeriod)];
}

- (void) writeScore {
    
    NSLog(@"written score down!");
    [inputScores writeValue:[NSNumber numberWithInt:1]
                   withDate:[NSDate date]
                 ofVariable:@"Pomodoros"];
    
    NSNumber* totalScore = [inputScores totalValueForDate:[NSDate date]
                                              forVariable:@"Pomodoros"];
    
    [dailyScores writeValue:totalScore
                   withDate:[NSDate date]
                 ofVariable:@"Pomodoros"];
}

- (void) startWorkState {
    timePeriod = workPeriodInSeconds;
    self.breaktime = NO;
    [self.delegate setupWorkView];
}

- (void) startBreakState {
    timePeriod = breakPeriodInSeconds;
    self.breaktime = YES;
    [self.delegate setupBreakView];
}


# pragma mark - app suspension

- (void) suspendTimer {
    int todaySince1970 = (int)[[NSDate date] timeIntervalSince1970];
    
    [settings setInteger:self.seconds forKey:@"PomodoroSeconds"];
    [settings setInteger:todaySince1970 forKey:@"PomodoroAwayDate"];
    [settings setBool:self.breaktime forKey:@"PomodoroBreakTime"];
    [settings setBool:self.timerIsOn forKey:@"PomodoroTimerIsOn"];
    [settings synchronize];
    
    NSLog(@"settings are saved");
}

- (BOOL) checkForSuspendedTimer {
    NSLog(@"checking in brain");
    if ([settings integerForKey:@"PomodoroAwayDate"]) {
        [self continueTimer];
        return 1;
    }
    else {
        return 0;
    }
}

- (void) continueTimer {
    
    int wentawayInt = (int)[settings integerForKey:@"PomodoroAwayDate"];
    NSDate* wentAwayDate = [NSDate dateWithTimeIntervalSince1970:wentawayInt];
    
    BOOL historicalBreaktime = [settings boolForKey:@"PomodoroBreakTime"];
    int historicalSeconds = (int)[settings integerForKey:@"PomodoroSeconds"];
    
    int intervalSinceWentAway = (int)[[NSDate date] timeIntervalSinceDate:wentAwayDate];
    int countDownInterval = intervalSinceWentAway + historicalSeconds;
    
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
    self.timerIsOn = [settings boolForKey:@"PomodoroTimerIsOn"];
    
    [self updateView];
    
    if (self.timerIsOn == YES) {
        [self startWorkState];
        [self startTimer];
    }
    else {
        [self startBreakState];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [settings removeObjectForKey:@"PomodoroAwayDate"];
        [settings removeObjectForKey:@"PomodoroBreakTime"];
        [settings removeObjectForKey:@"PomodoroSeconds"];
        [settings removeObjectForKey:@"PomodoroTimerIsOn"];
        [settings synchronize];
    });
        
    
}




@end
