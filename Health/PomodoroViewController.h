//
//  PomodoroViewController.h
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
//  ViewController containing UI-elements of a pomodoro-tracker. For every 25 min's of work,
//  user gets a new star. Stars reset every day, but score is saved.

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"
#import "PomodoroBrain.h"

@interface PomodoroViewController : UIViewController <MSPageViewControllerChild, PomodoroUpdateProtocol>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgress;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end
