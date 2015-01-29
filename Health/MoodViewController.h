//
//  MoodViewController.h
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
// ViewController in which the user can input how they feel.

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"
#import "InputScores.h"
#import "DailyScores.h"
#import "MoodTimeLabel.h"
#import "MoodScoreButton.h"

@interface MoodViewController : UIViewController <MSPageViewControllerChild>

@property (weak, nonatomic) IBOutlet MoodScoreButton *bestButton;
@property (weak, nonatomic) IBOutlet MoodScoreButton *goodButton;
@property (weak, nonatomic) IBOutlet MoodScoreButton *neutralButton;
@property (weak, nonatomic) IBOutlet MoodScoreButton *badButton;
@property (weak, nonatomic) IBOutlet MoodScoreButton *worstButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *scoreViewSegmentedControl;

@end