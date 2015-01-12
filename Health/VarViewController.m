//
//  VarViewController.m
//  Health
//
//  Created by Bas Oppenheim on 11-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "VarViewController.h"

@interface VarViewController ()

@end

@implementation VarViewController

#pragma mark - Managing the detail item

- (void)setVariable:(id)newVariable {
    if (_variable != newVariable) {
        _variable = newVariable;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.variable) {
        self.varTitle.title = [self.variable.varName description];
        self.lastRatingLabel.text = [NSString stringWithFormat:@"%i", self.variable.lastRating];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end