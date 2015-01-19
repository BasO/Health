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
        
        self.lastRatingLabel.text = [NSString stringWithFormat:@"%@", [self inputValueForIndex:[[self lastVariableIndex] integerValue]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    NSLog(@"varviewcontroller");
    NSLog(@"%@", [self allData]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    return (int)[[[self variableData] allKeys] count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    
    return [[self inputValueForIndex:index] floatValue];
    
    // return [[self.arrayOfValues objectAtIndex:index] floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = [NSString stringWithFormat:@"%@", [self inputTimeForIndex:index]];
    
    // NSString *label = [self.arrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}


- (NSDictionary*)allData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"HappinessScores.plist"];
    
    return [[[NSDictionary alloc] initWithContentsOfFile:path]mutableCopy];
}

- (NSDictionary*)variableData {
    return [[NSDictionary alloc] initWithDictionary:[[self allData] objectForKey:self.variable]];
}

- (NSString*) lastVariableIndex {
    NSMutableArray*keys = [[NSMutableArray alloc] initWithArray:[[self variableData] allKeys]];
    
    [keys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    return [keys lastObject];
}

- (NSDictionary*) lastVariableInput {
    return [[self variableData] objectForKey:[self lastVariableIndex]];
}

- (NSDate*) inputTimeForIndex:(NSInteger)index {
    return [[[self variableData] objectForKey:[NSString stringWithFormat:@"%08i", (int)index]] objectForKey:@"time"];
}

- (NSNumber*) inputValueForIndex:(NSInteger)index {
    return [[[self variableData] objectForKey:[NSString stringWithFormat:@"%08i", (int)index]] objectForKey:@"value"];
}

@end