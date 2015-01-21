//
//  VariableViewController.m
//  Health
//
//  Created by Bas Oppenheim on 11-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "VariableViewController.h"

@interface VariableViewController ()

@end

@implementation VariableViewController

DailyScores* dailyScores;

#pragma mark - Managing the detail item

- (void)setVariable:(NSString*)newVariable {
    if (_variable != newVariable) {
        _variable = newVariable;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    [self.graph reloadGraph];
    
    if (self.variable) {
        self.varTitle.title = [NSString stringWithString:self.variable];
        
        NSString* lastSaveKey = [[dailyScores saveKeysFor:self.variable] lastObject];
        NSDictionary* lastSample = [[dailyScores variableDict:self.variable] objectForKey:lastSaveKey];
        NSNumber* dayScoreNumber = [lastSample valueForKey:@"value"];
                                 
        self.lastRatingLabel.text = [NSString stringWithFormat:@"%@", dayScoreNumber];
    }
}

# pragma mark - viewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dailyScores = [[DailyScores alloc] init];
    
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated {
    if ([dailyScores syncDailyDict]) {
        [self configureView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma - graph

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [[dailyScores variableDict:self.variable] count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[[self sampleForIndex:index] objectForKey:@"value"] floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSDate* dateOfSample = [[self sampleForIndex:index] objectForKey:@"time"];
    NSString *label = [NSString stringWithFormat:@"%@", dateOfSample];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (NSDictionary*) sampleForIndex:(NSInteger)index {
    NSString* keyOfIndex = [[dailyScores saveKeysFor:self.variable] objectAtIndex:index];
    return [[dailyScores variableDict:self.variable] objectForKey:keyOfIndex];
}


@end