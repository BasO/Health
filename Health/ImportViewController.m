//
//  LogViewController.m
//  Health
//
//  Created by Bas Oppenheim on 09-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "ImportViewController.h"

@interface ImportViewController ()

@end

@implementation ImportViewController
{
    HKHealthStore *healthStore;
    NSTimeInterval totalAwakeSince15;
    int numberOfSleepRecordings;
    PListFunctions* plist;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    healthStore = [[HKHealthStore alloc] init];
    
    [self requestHealthAccess];
    
    plist = [[PListFunctions alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestHealthAccess {
    NSSet *readObjectTypes = [NSSet setWithObjects:
                              [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis],
                              [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierStepCount],
                              nil];
    
    [healthStore requestAuthorizationToShareTypes:0
                                        readTypes:readObjectTypes
                                       completion:^(BOOL success, NSError *error) {
                                           
                                           if(success == YES)
                                           {
                                               // ...
                                           }
                                           else
                                           {
                                               // Determine if it was an error or if the
                                               // user just canceld the authorization request
                                           }
                                           
                                       }];
}

- (IBAction)averageButtonPress:(id)sender {
    [self setAverage];
}


- (IBAction)sleepButtonPress:(id)sender {
    [self importSleep];
}

- (IBAction)stepsButtonPress:(id)sender {
    [self importSteps];
}



- (void) setAverage {
    
    totalAwakeSince15 = 0;
    numberOfSleepRecordings = 0;
    
    NSDate* endDate = [NSDate date];
     
    NSDate* startDate = [endDate dateByAddingTimeInterval:-(60*60*24*7)];
    
    NSLog(@"----- startdate is %@, enddate is %@ -----", startDate, endDate);
     
    // use the sample type for sleep
    HKSampleType *sampleType = [HKSampleType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
     
    // Create a predicate to set start/end date bounds of the query
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
     
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
     
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
    predicate:predicate
    limit:HKObjectQueryNoLimit
    sortDescriptors:@[sortDescriptor]
    resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(!error && results)
        {
            
            for(HKCategorySample *samples in results)
            {
                NSLog(@"found %@", [samples startDate]);
                
                
                NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
                [gregorian setTimeZone:gmt];
                NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: [samples startDate]];
                
                NSInteger hour = [components hour];
                int hourInt = hour;
                
                NSLog(@"hour is %i", hourInt);
                
                if ([components hour] < 14)
                    [components setDay: ([components day] - 1)];
                [components setHour: 15];
                [components setMinute:0];
                [components setSecond: 0];
                NSDate *comparisonDate = [gregorian dateFromComponents: components];
                
                NSLog(@"Comparing %@ to %@", comparisonDate, [samples startDate]);
                
                NSLog(@"interval is %f", [[samples startDate] timeIntervalSinceDate: comparisonDate]);
                
                totalAwakeSince15 += [[samples startDate] timeIntervalSinceDate:comparisonDate];
                
                numberOfSleepRecordings += 1;
                
                NSLog(@"totalAwake is %f, number is %i", totalAwakeSince15, numberOfSleepRecordings);
            }
            
            NSLog(@"you slept %f for %i times", totalAwakeSince15, numberOfSleepRecordings);
            
            NSTimeInterval averageAwakeSince15 = (totalAwakeSince15 / numberOfSleepRecordings);
            
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
            [gregorian setTimeZone:gmt];
            NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: [NSDate date]];
            
            [components setHour: 15];
            [components setMinute:0];
            [components setSecond: 0];
            NSDate *comparisonDate = [gregorian dateFromComponents: components];
            
            self.datePicker.date = [NSDate dateWithTimeInterval:averageAwakeSince15 sinceDate:comparisonDate];
            
        }
    }];
    
    // Execute the query
    dispatch_group_t d_group = dispatch_group_create();
    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(d_group, bg_queue, ^{
        [healthStore executeQuery:sampleQuery];
    });
    
    
    NSLog(@"DONE");
}


- (void) importSleep {
    
    NSDate* endDate = [NSDate date];
    
    NSDate* startDate = [endDate dateByAddingTimeInterval:-(60*60*24*30)];
    
    NSLog(@"----- startdate is %@, enddate is %@ -----", startDate, endDate);
    
    // use the sample type for sleep
    HKSampleType *sampleType = [HKSampleType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    // Create a predicate to set start/end date bounds of the query
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                if(!error && results)
                                                                {
                                                                    
                                                                    for(HKCategorySample *samples in results)
                                                                    {
                                                                        
                                                                        NSTimeInterval timeAsleep = [[samples endDate] timeIntervalSinceDate:[samples startDate]];
                                                                        
                                                                        [plist writeDailyValue:[NSNumber numberWithFloat:timeAsleep]
                                                                                      withDate:[samples endDate]
                                                                                    ofVariable:@"Sleep"];
                                                                    }
                                                                    
                                                                    NSLog(@"sleepDict is %@", [plist dailyDict]);
                                                                }
                                                            }];
    
    // Execute the query
    dispatch_group_t d_group = dispatch_group_create();
    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(d_group, bg_queue, ^{
        [healthStore executeQuery:sampleQuery];
    });
    
    NSLog(@"DONE");
}

- (void) importSteps {
    
    NSLog(@"importing steps");
    
    NSDate* endDate = [NSDate date];
    
    NSDate* startDate = [endDate dateByAddingTimeInterval:-(60*60*24*30)];
    
    // Use the sample type for step count
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create a predicate to set start/end date bounds of the query
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    NSInteger dailySteps;
                                                                    
                                                                    NSMutableString* currentDate = [[NSMutableString alloc] init];
                                                                    
                                                                    NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
                                                                    [timeFormat setDateFormat:@"YYYYMMdd"];
                                                                    
                                                                    for(HKQuantitySample *samples in results)
                                                                    {
                                                                        if (currentDate != [timeFormat stringFromDate:[samples endDate]]) {
                                                                            NSLog(@"currentDate is %@. newDate is %@.", currentDate, [timeFormat stringFromDate:[samples endDate]]);
                                                                            if (dailySteps != 0) {
                                                                                [plist writeDailyValue:[NSNumber numberWithInteger:dailySteps] \
                                                                                              withDate:[samples endDate]
                                                                                            ofVariable:@"Steps"];
                                                                                [currentDate setString:[timeFormat stringFromDate:[samples endDate]]];
                                                                                dailySteps = 0;
                                                                            }
                                                                            
                                                                            NSLog(@"%i", [samples quantity]);
                                                                            NSString* dailyStepsQuantity = [[NSString alloc] initWithFormat:@"%@", [samples quantity]];
                                                                            
                                                                            NSArray* dailyStepsArray = [dailyStepsQuantity componentsSeparatedByString:@" "];
                                                                            
                                                                            int sampleSteps = [[dailyStepsArray objectAtIndex:0] intValue];
                                                                            
                                                                            dailySteps += sampleSteps;
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }];
    // Execute the query
    [healthStore executeQuery:sampleQuery];
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