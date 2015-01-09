//
//  InViewController.m
//  Health
//
//  Created by Bas Oppenheim on 08-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "InViewController.h"

@interface InViewController ()

@end

@implementation InViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


+ (void)initialize {
    if (self == InViewController.class) {
        
        UIPageControl *pageControl = UIPageControl.appearance;
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
}

- (NSArray *)pageIdentifiers {
    return @[@"happinessViewController", @"pomodoroViewController"];
}


@end
