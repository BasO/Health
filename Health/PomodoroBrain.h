//
//  PomodoroBrain.h
//  Health
//
//  Created by Bas Oppenheim on 28-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputScores.h"
#import "DailyScores.h"

@protocol PomodoroUpdateProtocol
- (void)updateProgressTo:(float)progress;
- (void) updateMinutesTo:(int)minutes;
- (void)updatePomodorosTo:(int)pomodoros;
- (void) setupWorkView;
- (void) setupBreakView;

@end


@interface PomodoroBrain : NSObject

@property (nonatomic, weak) id <PomodoroUpdateProtocol> delegate;
@property (nonatomic) int seconds;
@property (nonatomic) BOOL breaktime;
@property (nonatomic) BOOL timerIsOn;
@property (nonatomic) NSTimer* pomodoroTimer;

- (id)init;
- (void) updateView;

- (void) suspendTimer;
- (BOOL) checkForSuspendedTimer;

- (void) startTimer;
- (void) stopTimer;
- (void) resetTimer;

- (void) startWorkState;
- (void) startBreakState;


@end
