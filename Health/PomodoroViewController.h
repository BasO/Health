//
//  PomodoroViewController.h
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"
#import "InputScores.h"
#import "DailyScores.h"

@interface PomodoroViewController : UIViewController <MSPageViewControllerChild>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgress;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void) updatePomodoroTimer;


@end
