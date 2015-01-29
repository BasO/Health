//
//  CorrelationsViewController.m
//  Health
//
//  Created by Bas Oppenheim on 23-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "CorrelationsViewController.h"

@interface CorrelationsViewController ()

@end

@implementation CorrelationsViewController

NSMutableArray* correlationsList;
Statistics* statistics;
NSMutableArray* notEnoughDataList;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    statistics = [[Statistics alloc] init];
    
    [self setupTableArrays];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupTableArrays];
    [self.tableView reloadData];
}

// setup the correlationsList and the notEnoughDataList
- (void) setupTableArrays {
    
    NSMutableArray* allVariables = [[NSMutableArray alloc] initWithArray:[statistics allVariables]];
    
    correlationsList = [[NSMutableArray alloc] init];
    notEnoughDataList = [[NSMutableArray alloc] init];
    
    // eliminate from allVariables the variables that don't have enough data for correlation calculation
    for (NSString* variable in allVariables) {
        NSNumber* correlation = [statistics pearsonCorrelationOfVariable1:variable andVariable2:variable];
        if ([[NSString stringWithFormat:@"%@", correlation] isEqualToString:@"nan"]) {
            [notEnoughDataList addObject:variable];
        }
    }
    [allVariables removeObjectsInArray:notEnoughDataList];
    
    NSMutableArray* processedVariableCouplesHashList = [[NSMutableArray alloc] init];
    
    for (NSString* variable1 in allVariables) {
        for (NSString* variable2 in allVariables) {
            
            // make sure that correlations are not calculated twice
            NSString* reversedStringHash = [NSString stringWithFormat:@"%@%@", variable2, variable1];
            if (![variable2 isEqualToString:variable1] && ![processedVariableCouplesHashList containsObject:reversedStringHash]) {
                
                float correlation = [[statistics pearsonCorrelationOfVariable1:variable1 andVariable2:variable2] floatValue];
                
                // send correlation calculations that imply error or not enough data to the notEnoughDataList
                if ([[NSString stringWithFormat:@"%f", correlation] isEqual:@"nan"] || correlation >= 1 || correlation <= -1) {
                    NSString* columnText = [[NSString alloc] initWithFormat:@"%@ x %@", variable1, variable2];
                    [notEnoughDataList addObject:columnText];
                }
                
                // display correct correlations as a percentage, send these to the correlationsList
                else {
                    correlation *= 100;
                    NSString* columnText = [[NSString alloc] initWithFormat:@"%@ x %@: %.0f%%", variable1, variable2, correlation];
                    [correlationsList addObject:columnText];
                }
                [processedVariableCouplesHashList addObject:[NSString stringWithFormat:@"%@%@", variable1, variable2]];
                
            }
        }
    }
    
    // if a variable correlates with no variable, make it a single item on the notEnoughDataList
    for (NSString* variable in allVariables) {
        
        // calculate how often a variable correlates with no variable
        int variableHitCount = 0;
        for (NSString* columnText in notEnoughDataList) {
            if ([columnText rangeOfString:variable].location != NSNotFound) {
                variableHitCount += 1;
            }
        }
        
        // exchange all its appearances on the notEnoughDataList for one NSString of the variable name
        if (variableHitCount >= [allVariables count] - 1) {
            NSArray *notEnoughDataListCopy = [[NSArray alloc] initWithArray:notEnoughDataList];
            for (NSString* columnText in notEnoughDataListCopy) {
                if ([columnText rangeOfString:variable].location != NSNotFound) {
                    [notEnoughDataList removeObject:columnText];
                }
            }
            [notEnoughDataList addObject:variable];
        }
    }
    
    [correlationsList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [notEnoughDataList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


#pragma mark - Table View

// Set number of sections, accounting for whether the correlationsList and notEnoughDataList contain variables
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int numberOfSections = 2;
    if (!correlationsList)
        numberOfSections -= 1;
    if (!notEnoughDataList)
        numberOfSections -= 1;
    return numberOfSections;
}

// Set section header titles.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* correlationsHeader = [[NSString alloc] initWithFormat:@"Correlations:"];
    NSString* notEnoughDataHeader = [[NSString alloc] initWithFormat:@"Not enough days of data for:"];
    
    if (!correlationsList && !(!notEnoughDataList)) {
        return notEnoughDataHeader;
    }
    else if (!!correlationsList) {
        if(section == 0)
            return correlationsHeader;
        if(section == 1)
            return notEnoughDataHeader;
    }
    return 0;
}

// Set section footer messages.
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSString* pearsonExplanationFooter = [[NSString alloc] initWithFormat:
                                          @"Based on the Pearson product-moment correlation coefficient. Correlation expressed as a value between -1 and 1, whereby 1 is a positive correlation, 0 is no correlation and -1 is a negative correlation."];
    
    NSString* notEnoughDataFooter = [[NSString alloc] initWithFormat:
                                     @"At least two days of data are necessary, though the more data you collect, the more accurate your correlations will be."];
    
    if (!correlationsList && !(!notEnoughDataList)) {
        return notEnoughDataFooter;
    }
    else if (!!correlationsList) {
        if (section == 0) {
            return pearsonExplanationFooter;
        }
        if (section == 1) {
            return notEnoughDataFooter;
        }
    }
    return 0;
}

// Set number of rows per section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!correlationsList && !(!notEnoughDataList)) {
        return notEnoughDataList.count;
    }
    else if (!!correlationsList) {
        if (section == 0) {
            return correlationsList.count;
        }
        if (section == 1) {
            return notEnoughDataList.count;
        }
    }
    return 0;
}

// Setup cells of graph, using nsstrings from correlationsList and notEnoughDataList
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (!correlationsList && !(!notEnoughDataList)) {
        NSString *string = notEnoughDataList[indexPath.row];
        cell.textLabel.text = [string description];;
    }
    else if (!!correlationsList) {
        if (indexPath.section == 0) {
            cell.textLabel.text = correlationsList[indexPath.row];
        }
        if (indexPath.section == 1) {
            cell.textLabel.text = notEnoughDataList[indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark - other functions

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
