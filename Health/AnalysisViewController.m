//
//  AnalysisViewController.m
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "AnalysisViewController.h"

@interface AnalysisViewController ()

@end

@implementation AnalysisViewController

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
    if (self == AnalysisViewController.class) {
        
        UIPageControl *page2Control = UIPageControl.appearance;
        page2Control.backgroundColor = [UIColor whiteColor];
        page2Control.pageIndicatorTintColor = [UIColor lightGrayColor];
        page2Control.currentPageIndicatorTintColor = [UIColor blackColor];
        
    }
}

- (NSArray *)pageIdentifiers {
    return @[@"networkViewController", @"sortedViewController"];
}

@end
