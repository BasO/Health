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
    DailyScores* dailyScores;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dailyScores = [[DailyScores alloc] init];
    healthStore = [[HKHealthStore alloc] init];
    
    [self requestHealthAccess];
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
                NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
                [gregorian setTimeZone:gmt];
                NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: [samples startDate]];
                
                if ([components hour] < 14)
                    [components setDay: ([components day] - 1)];
                [components setHour: 15];
                [components setMinute:0];
                [components setSecond: 0];
                NSDate *comparisonDate = [gregorian dateFromComponents: components];
                
                totalAwakeSince15 += [[samples startDate] timeIntervalSinceDate:comparisonDate];
                numberOfSleepRecordings += 1;
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
    
    [healthStore executeQuery:sampleQuery];
    
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
                                                                        
                                                                        [dailyScores writeValue:[NSNumber numberWithFloat:timeAsleep]
                                                                                       withDate:[samples endDate]
                                                                                     ofVariable:@"Sleep"];
                                                                    }
                                                                }
                                                            }];
    
    [healthStore executeQuery:sampleQuery];
    
    NSLog(@"DONE");
}

- (void) importSteps {
    
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* startOfToday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    
    NSLog(@"importing steps");
    
    // import steps PER DAY. Best way (for now) to get the cumulative number of steps per day.
    for (int i = 0; i < 30; i++) {
        
        NSDate* endDate = [startOfToday dateByAddingTimeInterval:-(60*60*24 * i)];
        
        NSDate* startDate = [endDate dateByAddingTimeInterval:-(60*60*24)];
        
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
                                                                        NSInteger dailySteps = 0;
                                                                        NSDate* lastDate;
                                                                        
                                                                        for(HKQuantitySample *samples in results)
                                                                        {
                                                                            NSString* dailyStepsQuantity = [[NSString alloc] initWithFormat:@"%@", [samples quantity]];
                                                                            
                                                                            NSArray* dailyStepsArray = [dailyStepsQuantity componentsSeparatedByString:@" "];
                                                                            
                                                                            int sampleSteps = [[dailyStepsArray objectAtIndex:0] intValue];
                                                                            
                                                                            dailySteps += sampleSteps;
                                                                            
                                                                            lastDate = [samples endDate];
                                                                        }
                                                                        
                                                                        NSLog(@"IS - lastdate is %@", lastDate);
                                                                        
                                                                        [dailyScores writeValue:[NSNumber numberWithInteger:dailySteps]
                                                                                       withDate:lastDate
                                                                                     ofVariable:@"Steps"];
                                                                    }
                                                                }];
            
        // Execute the query
        [healthStore executeQuery:sampleQuery];
    }
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