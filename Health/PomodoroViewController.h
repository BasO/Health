//
//  PomodoroViewController.h
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"

@interface PomodoroViewController : UIViewController <MSPageViewControllerChild>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgress;

@property (nonatomic, assign) NSTimer *timer;
@property BOOL timerOn;


@end
