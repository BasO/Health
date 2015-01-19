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

@interface LogViewController ()

@end

@implementation LogViewController
{
    NSArray* vars;
    HKHealthStore *healthStore;
}



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    vars = [[NSArray alloc] initWithArray:[[self allData] allKeys]];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        NSIndexPath *indexPath = [self.psychoTable indexPathForSelectedRow];
        NSString* variable = vars[indexPath.row];
        [varViewController setVariable:variable];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Conditionally perform segues, here is an example:
    
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    [self.psychoTable deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Table View

/*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [vars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [vars objectAtIndex:indexPath.row];
    return cell;
}

- (NSDictionary*)allData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"HappinessScores.plist"];
    
    return [[[NSDictionary alloc] initWithContentsOfFile:path]mutableCopy];
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