//
//  LogViewController.m
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "LogViewController.h"
#import "VarViewController.h"
#import "InAppVar.h"
#import "PListFunctions.h"

@interface LogViewController ()

@end

@implementation LogViewController
{
    NSArray* vars;
    HKHealthStore *healthStore;
    PListFunctions* plist;
    
    NSMutableArray* inputVariables;
    NSMutableArray* healthVariables;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupTableArrays];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self setupTableArrays];
    [self.tableView reloadData];
    
    NSLog(@"all vars are: %@", vars);
    
    NSLog(@"dict is %@", [plist dailyDict]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableArrays {
    
    plist = [[PListFunctions alloc] init];
    vars = [[NSArray alloc] initWithArray:[[plist dailyDict] allKeys]];
    
    NSLog(@"DAILYDICT ALLKEYS is %@", [[plist dailyDict] allKeys]);
    inputVariables = [[NSMutableArray alloc] init];
    healthVariables = [[NSMutableArray alloc] init];
    
    for (NSString *variable in vars) {
        if ([variable compare:@"Happiness"] == NSOrderedSame ||
            [variable compare:@"Pomodoros"] == NSOrderedSame
            ||
            [variable compare:@"Water"] == NSOrderedSame)
        {
            
            [inputVariables addObject:variable];
        }
        else
            [healthVariables addObject:variable];
    }
    
    NSLog(@"HEALTHVARIABLES IS %@", healthVariables);
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
        
        VarViewController *varViewController = (VarViewController *)segue.destinationViewController;
        
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
        
        [varViewController setVariable:[NSString stringWithString:variable]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Conditionally perform segues, here is an example:
    
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    [self.psychoTable deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Table View



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (2 - !([inputVariables count] > 0) - !([healthVariables count] > 0));
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([healthVariables count] > 0 && !([inputVariables count] > 0)) {
        return @"HEALTH";
    }
    else
    if ([inputVariables count] > 0) {
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

    return cell;
}


- (NSString*) pathOfPList:(NSString*)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
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