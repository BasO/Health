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
    
    plist = [[PListFunctions alloc] init];
    [self.graph reloadGraph];
    
    if (self.variable) {
        self.varTitle.title = [NSString stringWithString:self.variable];
        
        NSString* lastSaveKey = [[plist dailyDictKeysFor:self.variable] lastObject];
        NSDictionary* lastSample = [[plist variableDailyDict:self.variable] objectForKey:lastSaveKey];
        NSNumber* dayScoreNumber = [lastSample valueForKey:@"value"];
        self.lastRatingLabel.text = [NSString stringWithFormat:@"%@", dayScoreNumber];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    plist = [[PListFunctions alloc] init];
    
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma - graph

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [[plist dailyDictKeysFor:self.variable] count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSString* keyOfIndex = [[plist dailyDictKeysFor:self.variable] objectAtIndex:index];
    NSDictionary* sampleDictOfIndex = [[plist variableDailyDict:self.variable] objectForKey:keyOfIndex];
    NSNumber* valueOfSample = [sampleDictOfIndex objectForKey:@"value"];
    
    return [valueOfSample floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString* keyOfIndex = [[plist dailyDictKeysFor:self.variable] objectAtIndex:index];
    NSDictionary* sampleDictOfIndex = [[plist variableDailyDict:self.variable] objectForKey:keyOfIndex];
    NSDate* dateOfSample = [sampleDictOfIndex objectForKey:@"time"];
    
    NSString *label = [NSString stringWithFormat:@"%@", dateOfSample];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}


@end