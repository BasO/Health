//
//  LogViewController.m
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "LogViewController.h"
#import "VariableViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

NSArray* vars;
HKHealthStore *healthStore;
DailyScores* dailyScores;

NSMutableArray* inputVariables;
NSMutableArray* importVariables;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dailyScores = [[DailyScores alloc] init];
    
    [self setupTableArrays];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([dailyScores syncDailyDict]) {
        [self setupTableArrays];
        [self.tableView reloadData];
    }
}

// Setup the array that will be used to fill the tableView
- (void)setupTableArrays {
    
    // get alphabetic list of available variables
    NSMutableArray* unsortedVars = [[NSMutableArray alloc] initWithArray:[[dailyScores dailyDict] allKeys]];
    [unsortedVars sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    vars = [[NSArray alloc] initWithArray:unsortedVars];
    
    // sort variables into categories (for sections)
    inputVariables = [[NSMutableArray alloc] init];
    importVariables = [[NSMutableArray alloc] init];
    for (NSString *variable in vars) {
        if ([variable compare:@"Mood"] == NSOrderedSame ||
            [variable compare:@"Pomodoros"] == NSOrderedSame ||
            [variable compare:@"Water"] == NSOrderedSame) {
            [inputVariables addObject:variable];
        }
        else
            [importVariables addObject:variable];
    }
}

#pragma mark - Segues
// Send touched variable name to VariableViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"])
    {

        VariableViewController *variableViewController = (VariableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSMutableString* variable = [[NSMutableString alloc] init];
        if ([importVariables count] > 0 && !([inputVariables count] > 0)) {
            variable = importVariables[indexPath.row];
        }
        else {
            if (indexPath.section == 0) {
                variable = inputVariables[indexPath.row];
            }
            else if (indexPath.section == 1) {
                variable = importVariables[indexPath.row];
            }
        }
        
        [variableViewController setVariable:[NSString stringWithString:variable]];
    }
}

#pragma mark - Table View setup

// Do a segue on selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// Set the number of sections, based on whether there are input- and/or import variables.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int numberOfSections = 2;
    if (!([inputVariables count] > 0))
        numberOfSections -= 1;
    if (!([importVariables count] > 0))
        numberOfSections -= 1;
    
    return numberOfSections;
}

// Set the section headers.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* inputVariablesHeader = @"MEASURED IN THIS APP";
    NSString* importVariablesHeader = @"IMPORTED FROM OTHER APPS";
    
    if ([self checkIfOnlyImportVariables]) {
        return importVariablesHeader;
    }
    else if ([inputVariables count] > 0) {
        if(section == 0)
            return inputVariablesHeader;
        if(section == 1)
            return importVariablesHeader;
    }
    return 0;
}

// Set the number of rows per section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self checkIfOnlyImportVariables]) {
        return [importVariables count];
    }
    else {
        if (section == 0) {
            return [inputVariables count];
        }
        if (section == 1) {
            return [importVariables count];
        }
    }
    return 0;
}

// Setup each cell of the table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // prepare cell
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // set either input- or import variables as text for each cell
    if ([self checkIfOnlyImportVariables]) {
        cell.textLabel.text = [importVariables objectAtIndex:indexPath.row];
    }
    else {
        if (indexPath.section == 0)
            cell.textLabel.text = [inputVariables objectAtIndex:indexPath.row];
        
        if (indexPath.section == 1)
            cell.textLabel.text = [importVariables objectAtIndex:indexPath.row];
    }
    
    return cell;
}

# pragma mark - helper functions

- (BOOL) checkIfOnlyImportVariables {
    return ([importVariables count] > 0 && !([inputVariables count] > 0));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end