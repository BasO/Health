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
NSMutableArray* healthVariables;


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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableArrays {
    
    // get alphabetic list of available variables
    NSMutableArray* unsortedVars = [[NSMutableArray alloc] initWithArray:[[dailyScores dailyDict] allKeys]];
    [unsortedVars sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    vars = [[NSArray alloc] initWithArray:unsortedVars];
    
    // sort variables into categories (for sections)
    inputVariables = [[NSMutableArray alloc] init];
    healthVariables = [[NSMutableArray alloc] init];
    for (NSString *variable in vars) {
        if ([variable compare:@"Happiness"] == NSOrderedSame ||
            [variable compare:@"Pomodoros"] == NSOrderedSame ||
            [variable compare:@"Water"] == NSOrderedSame) {
            [inputVariables addObject:variable];
        }
        else
            [healthVariables addObject:variable];
    }
}

#pragma mark - Segues
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.psychoTable indexPathForSelectedRow];
        NSDate *object = vars[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"])
    {

        VariableViewController *variableViewController = (VariableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSMutableString* variable = [[NSMutableString alloc] init];
        if ([healthVariables count] > 0 && !([inputVariables count] > 0)) {
            variable = healthVariables[indexPath.row];
        }
        else {
            if (indexPath.section == 0) {
                variable = inputVariables[indexPath.row];
            }
            else if (indexPath.section == 1) {
                variable = healthVariables[indexPath.row];
            }
        }
        
        [variableViewController setVariable:[NSString stringWithString:variable]];
    }
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Conditionally perform segues, here is an example:
    
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (2 - !([inputVariables count] > 0) - !([healthVariables count] > 0));
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([healthVariables count] > 0 && !([inputVariables count] > 0)) {
        return @"HEALTH";
    }
    else if ([inputVariables count] > 0) {
        if(section == 0)
            return @"THIS APP";
        if(section == 1)
            return @"OTHER APPS";
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([healthVariables count] > 0 && !([inputVariables count] > 0)) {
        return [healthVariables count];
    }
    else {
        if (section == 0) {
            NSLog(@"inputVariables count is %lu", (unsigned long)[inputVariables count]);
            return [inputVariables count];
        }
        if (section == 1) {
            NSLog(@"healthVariables count is %lu", [healthVariables count]);
            return [healthVariables count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ([healthVariables count] > 0 && !([inputVariables count] > 0)) {
        cell.textLabel.text = [healthVariables objectAtIndex:indexPath.row];
    }
    else {
        if (indexPath.section == 0)
            cell.textLabel.text = [inputVariables objectAtIndex:indexPath.row];
        
        if (indexPath.section == 1)
            cell.textLabel.text = [healthVariables objectAtIndex:indexPath.row];
    }
    
    /* 
     EXPERIMENTING WITH COLORS
     
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([cell.textLabel.text isEqual: @"Happiness"])
        cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:191/255.0f blue:0/255.0f alpha:0.15];
    if ([cell.textLabel.text isEqual: @"Steps"])
        cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:115/255.0f blue:0/255.0f alpha:0.15];
    if ([cell.textLabel.text isEqual: @"Sleep"])
        cell.backgroundColor = [UIColor colorWithRed:83/255.0f green:0/255.0f blue:255/255.0f alpha:0.15];
    if ([cell.textLabel.text isEqual: @"Water"])
        cell.backgroundColor = [UIColor colorWithRed:0/255.0f green:183/255.0f blue:255/255.0f alpha:0.15];

     */
    
    return cell;
}



/*

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_vars removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/

@end