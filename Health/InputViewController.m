//
//  InputViewController.m
//  Health
//
//  Created by Bas Oppenheim on 08-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

UIPageControl *pageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageControl = UIPageControl.appearance;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)pageIdentifiers {
    return @[@"MoodViewController", @"pomodoroViewController", @"waterViewController"];
}


@end
