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

NSMutableArray* sortedList;
Statistics* statistics;
NSMutableArray* notEnoughDataList;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    statistics = [[Statistics alloc] init];
    
    [self setupTableArrays];

}

-(void)viewWillAppear:(BOOL)animated {
        [self setupTableArrays];
        [self.tableView reloadData];
    
}

- (void) setupTableArrays {
    NSMutableArray* allVariables = [[NSMutableArray alloc] initWithArray:[statistics allVariables]];

    sortedList = [[NSMutableArray alloc] init];
    notEnoughDataList = [[NSMutableArray alloc] init];
    NSMutableArray* processedVariableCouplesHashList = [[NSMutableArray alloc] init];
    
    for (NSString* variable in allVariables) {
        NSNumber* correlation = [statistics pearsonCorrelationOfVariable1:variable andVariable2:variable];
        if ([[NSString stringWithFormat:@"%@", correlation] isEqualToString:@"nan"]) {
            [notEnoughDataList addObject:variable];
        }
    }
    
    [allVariables removeObjectsInArray:notEnoughDataList];
    
    for (NSString* variable1 in allVariables) {
        
        for (NSString* variable2 in allVariables) {
            
            NSString* reversedStringHash = [NSString stringWithFormat:@"%@%@", variable2, variable1];
            
            if (![variable2 isEqualToString:variable1] && ![processedVariableCouplesHashList containsObject:reversedStringHash]) {
                
                NSNumber* correlation = [statistics pearsonCorrelationOfVariable1:variable1 andVariable2:variable2];
                
                NSString* columnText = [[NSString alloc] initWithFormat:@"%@ %@ %@", correlation, variable1, variable2];
                
                [sortedList addObject:columnText];

                [processedVariableCouplesHashList addObject:[NSString stringWithFormat:@"%@%@", variable1, variable2]];
            }
        }
    }

    [sortedList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [notEnoughDataList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    NSLog(@"sortedList is %@", sortedList);
    NSLog(@"notEnoughDataList is %@", notEnoughDataList);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"numberofsects");
    return (2 - (!sortedList) - (!notEnoughDataList));
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (!sortedList && !(!notEnoughDataList)) {
        return @"NOT ENOUGH DAYS OF DATA FOR:";
    }
    else if (!!sortedList) {
        if(section == 0)
            return @"Correlations, from -1 to 1:";
        if(section == 1)
            return @"NOT ENOUGH DAYS OF DATA FOR:";
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (!sortedList && !(!notEnoughDataList)) {
        return @"At least two days of data are necessary, though the more data you collect, the more accurate your correlations will be.";
    }
    else if (!!sortedList) {
        if (section == 0) {
            return @"Based on the Pearson product-moment correlation coefficient. Correlation expressed as a value between -1 and 1, whereby 1 is a positive correlation, 0 is no correlation and -1 is a negative correlation.";
        }
        if (section == 1) {
            return @"At least two days of data are necessary, though the more data you collect, the more accurate your correlations will be.";
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberofrows is %lu", (unsigned long)sortedList.count);
    
    if (!sortedList && !(!notEnoughDataList)) {
        return notEnoughDataList.count;
    }
    else if (!!sortedList) {
        if (section == 0) {
            return sortedList.count;
        }
        if (section == 1) {
            return notEnoughDataList.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellforrow");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (!sortedList && !(!notEnoughDataList)) {
        NSString *string = notEnoughDataList[indexPath.row];
        cell.textLabel.text = [string description];;
    }
    else if (!!sortedList) {
        if (indexPath.section == 0) {
            NSArray* stringParts = [[NSArray alloc] initWithArray:[sortedList[indexPath.row] componentsSeparatedByString:@" "]];
            
            NSString *newString = [[NSString alloc] initWithFormat:@"%@ x %@:  %@", stringParts[1], stringParts[2], stringParts[0]];
            
            cell.textLabel.text = [newString description];;;
        }
        if (indexPath.section == 1) {
            NSString *string = notEnoughDataList[indexPath.row];
            cell.textLabel.text = [string description];;;
        }
    }
    
    return cell;
}


@end