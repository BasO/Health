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

# pragma mark - request Health Kit access

// Request access to Health Kit data.
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

#pragma mark - import buttons

- (IBAction)sleepButtonPress:(id)sender {
    [self importSleep];
}

- (IBAction)stepsButtonPress:(id)sender {
    [self importSteps];
}

#pragma mark - import data from Health Kit

// Import Sleep-data from Health Kit.
- (void) importSleep {
    
    NSDate* endDate = [NSDate date];
    NSDate* startDate = [endDate dateByAddingTimeInterval:-(60*60*24*60)];
    
    // setup sleep-data based query in Health Kit data
    HKSampleType *sampleType = [HKSampleType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
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
                                                                        // save seconds asleep with wake-up moment as time-value
                                                                        NSTimeInterval timeAsleep = [[samples endDate] timeIntervalSinceDate:[samples startDate]];
                                                                        
                                                                        [dailyScores writeValue:[NSNumber numberWithFloat:timeAsleep]
                                                                                       withDate:[samples endDate]
                                                                                     ofVariable:@"Sleep"];
                                                                    }
                                                                }
                                                            }];
    // execute query
    [healthStore executeQuery:sampleQuery];
}

// Import steps-data from Health Kit.
- (void) importSteps {
    
    // get nsdate of current day, 0:00:00
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* startOfToday = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    // have a distinct query for each day
    for (int i = 0; i < 60; i++) {
        
        NSDate* endDate = [startOfToday dateByAddingTimeInterval:-(60*60*24 * i)];
        NSDate* startDate = [endDate dateByAddingTimeInterval:-(60*60*24)];
        
        // setup steps-data based query in Health Kit data
        HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
        
        HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                     predicate:predicate
                                                                         limit:HKObjectQueryNoLimit
                                                               sortDescriptors:@[sortDescriptor]
                                                                resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                    
                                                                    if(!error && results)
                                                                    {
                                                                        // count together the sum of all results from one day;
                                                                        // and get the time of the last result
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
                                                                        // save the sum of result-values with the time of the last result
                                                                        [dailyScores writeValue:[NSNumber numberWithInteger:dailySteps]
                                                                                       withDate:lastDate
                                                                                     ofVariable:@"Steps"];
                                                                    }
                                                                }];
            
        // Execute the query
        [healthStore executeQuery:sampleQuery];
    }
}

@end