//
//  VariableViewController.m
//  Health
//
//  Created by Bas Oppenheim on 11-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "VariableViewController.h"
#import "Statistics.h"

@interface VariableViewController ()

@end

@implementation VariableViewController

int graphLength;
int pointsInLineGraph;

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
        
        Statistics* statistics = [[Statistics alloc] init];
        
        self.correlateLabel.text = [NSString stringWithFormat:@"%@", [statistics pearsonCorrelationOfVariable1:self.variable andVariable2:@"Steps"]];
    }
}

# pragma mark - viewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dailyScores = [[DailyScores alloc] init];
    
    graphLength = 7;
    
    self.graph.enableYAxisLabel = YES;
    self.graph.enableReferenceXAxisLines = YES;
    self.graph.enableReferenceYAxisLines = YES;
    self.graph.enableBezierCurve = YES;
    self.graph.animationGraphEntranceTime = 1;
    
    NSArray* saveKeys = [dailyScores saveKeysFor:self.variable];
    double startValue = [saveKeys count];
    int startValueInt = (int)startValue;
    
    if (startValueInt > 30) {
        [self.graphTimePeriodSegmentedControl insertSegmentWithTitle:@"Half year" atIndex: 2 animated:NO];
    }
    if (startValueInt > 182) {
        [self.graphTimePeriodSegmentedControl insertSegmentWithTitle:@"Year" atIndex:3 animated:NO];
    }
    
    graphLength = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"VariableGraphLength"];
    
    int numberOfSegments = (int)[self.graphTimePeriodSegmentedControl numberOfSegments];
    
    if (graphLength > 182 && numberOfSegments > 3) {
        self.graphTimePeriodSegmentedControl.selectedSegmentIndex = 3;
    }
    else if (graphLength > 30 && numberOfSegments > 2) {
        self.graphTimePeriodSegmentedControl.selectedSegmentIndex = 2;
    }
    else if (graphLength > 7 && numberOfSegments > 1) {
        self.graphTimePeriodSegmentedControl.selectedSegmentIndex = 1;
    }
    else if (graphLength && numberOfSegments > 0) {
        self.graphTimePeriodSegmentedControl.selectedSegmentIndex = 0;
    }
    
    
    
    [self configureView];
    
    
}
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray* saveKeys = [dailyScores saveKeysFor:self.variable];
    double startValue = [saveKeys count];
    int startValueInt = (int)startValue;
    
    if (startValueInt < 2) {
        return 1;
    }
    else
        return 2;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray* saveKeys = [dailyScores saveKeysFor:self.variable];
    double startValue = [saveKeys count];
    int startValueInt = (int)startValue;
    
    if (section == 1) {
        if (startValueInt < 2)
            return 0;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSArray* saveKeys = [dailyScores saveKeysFor:self.variable];
    double startValue = [saveKeys count];
    int startValueInt = (int)startValue;
    
    if (section == 1) {
        if (startValueInt < 2)
            return @"Collect at least two days of data to view a graph of your daily scores.";
    }
    return @"";
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


- (IBAction)graphTimePeriodSegmentedControlValueChange:(id)sender {
    [self.graph setAnimationGraphEntranceTime:0];
    
    NSInteger choice = self.graphTimePeriodSegmentedControl.selectedSegmentIndex;
    if (choice == 0)
        graphLength = 7;
    else if (choice == 1)
        graphLength = 30;
    else if (choice == 2)
        graphLength = 182;
    
    [[NSUserDefaults standardUserDefaults] setInteger:graphLength forKey:@"VariableGraphLength"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.graph reloadGraph];
}


# pragma - graph

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    NSInteger numberOfRecordedScores = [[dailyScores variableDict:self.variable] count];
    int numberOfRecordedScoresInt = (int)numberOfRecordedScores;
    
    
    
    if (numberOfRecordedScores > graphLength) {
        NSLog(@"index will be %i", graphLength);
        pointsInLineGraph = graphLength;
    }
    else {
        NSLog(@"index will be %i", numberOfRecordedScoresInt);
        pointsInLineGraph = numberOfRecordedScoresInt;
    }
    return pointsInLineGraph;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    if (pointsInLineGraph < 4)
        return 3;
    else
        return 5;
            
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    
    float valueForPoint = [[[self sampleForIndex:index] objectForKey:@"value"] floatValue];
    
    if ([self.variable isEqualToString:@"Sleep"]) {
        float hours = valueForPoint / (60 * 60);
        return round(hours * 10) / 10;
    }
    if ([self.variable isEqualToString:@"Water"]) {
        float hours = valueForPoint / (60 * 60);
        return round(hours * 10) / 100;
    }
    
    
    return [[[self sampleForIndex:index] objectForKey:@"value"] floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSDate* dateOfSample = [[self sampleForIndex:index] objectForKey:@"time"];
    NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
    
    NSMutableString* label = [[NSMutableString alloc] init];
    
    if (pointsInLineGraph < 10) {
        [timeFormat setDateFormat:@"EEE"];
    }
    else if (pointsInLineGraph < 50) {
        [timeFormat setDateFormat:@"d MMM"];
    }
    else {
        [timeFormat setDateFormat:@"   d MMM   "];
    }
    [label setString:[timeFormat stringFromDate:dateOfSample]];

    
    // NSString *label = [NSString stringWithFormat:@"%@", dateOfSample];
    return label;
    
    //[label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (NSDictionary*) sampleForIndex:(NSInteger)index {
    
    NSArray* saveKeys = [dailyScores saveKeysFor:self.variable];
    
    double startValue = [saveKeys count];
    int startValueInt = (int)startValue;
    int lengthOfRange = startValueInt;
    
    if (startValueInt > graphLength) {
        startValueInt -= graphLength;
        lengthOfRange = graphLength;
    }
    else {
        lengthOfRange = startValueInt;
        startValueInt = 0;
    }
    
    NSArray* saveKeysForView = [saveKeys subarrayWithRange: NSMakeRange(startValueInt, lengthOfRange)];
    
    NSString* keyOfIndex = [saveKeysForView objectAtIndex:index];
    return [[dailyScores variableDict:self.variable] objectForKey:keyOfIndex];
}


@end