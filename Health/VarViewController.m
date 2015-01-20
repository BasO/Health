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
{
    PListFunctions* plist;
}

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
    if (self.variable) {
        self.varTitle.title = [NSString stringWithString:self.variable];
        
        NSLog(@"last one was %@", [[self lastVariableInput] valueForKey:@"value"]);
        NSNumber* lastAverage = [[self lastVariableInput] valueForKey:@"value"];
        float lastAverageFloat = [lastAverage floatValue];
        
        self.lastRatingLabel.text = [NSString stringWithFormat:@"%f", lastAverageFloat];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    plist = [[PListFunctions alloc] init];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    NSLog(@"numberofPointsinLineGraph is %i", (int)[[[plist variableDailyDict:self.variable] allKeys] count]);
    
    return (int)[[[plist variableDailyDict:self.variable] allKeys] count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    
    NSLog(@"valueForPointAtIndex is %f", [[self inputValueForIndex:index] floatValue]);
    
    return [[self inputValueForIndex:index] floatValue];
    
    // return [[self.arrayOfValues objectAtIndex:index] floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = [NSString stringWithFormat:@"%@", [self inputTimeForIndex:index]];
    
    // NSString *label = [self.arrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (NSString*) lastVariableKey {
    return ([[plist dailyDictKeysFor:self.variable] lastObject]);
}

- (NSDictionary*) lastVariableInput {
    return [[plist variableDailyDict:self.variable] objectForKey:[self lastVariableKey]];
}

- (NSDate*) inputTimeForIndex:(NSInteger)index {
    return [[[plist variableDailyDict:self.variable] objectForKey:[[plist dailyDictKeysFor:self.variable] objectAtIndex:index]] objectForKey:@"time"];
}

- (NSNumber*) inputValueForIndex:(NSInteger)index {
    
    return [[[plist variableDailyDict:self.variable] objectForKey:[[plist dailyDictKeysFor:self.variable] objectAtIndex:index]] objectForKey:@"value"];
}


@end