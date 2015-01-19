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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timeProgress.progress = 0.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)timerButton:(id)sender {

    if ([self.startButton.titleLabel.text compare:@"Start"] == NSOrderedSame)
    {
        self.startButton.titleLabel.text = @"Stop";
        NSLog(@"starting pomo");
        
        [UIView animateWithDuration:(10)
                              delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             [self.timeProgress setProgress:1.0 animated:YES];
                             
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
