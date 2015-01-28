//
//  dailyScores.m
//  Health
//
//  Created by Bas Oppenheim on 21-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "DailyScores.h"

@implementation DailyScores

@synthesize dailyDict = _dailyDict;
@synthesize pathOfPList = _pathOfPList;

# pragma mark - read functions

// Returns all daily scores for one variable.
- (NSMutableDictionary*) variableDict:(NSString*)variable {
    return [[NSMutableDictionary alloc] initWithDictionary:[self.dailyDict objectForKey:variable]];
}

// Returns a sorted array of saveKeys in a variable
- (NSMutableArray *) saveKeysFor:(NSString*)variable {
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[[self variableDict:variable] allKeys]] ;
    [tempArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return tempArray;
}

- (NSNumber*) numberValueForSaveKey:(NSString*)saveKey ofVariable:(NSString*)variable {
    
    return [[[self variableDict:variable] objectForKey:saveKey] objectForKey:@"value"];
}


# pragma mark - write functions

// Write one daily sample to daily-dictionary.
- (void) writeValue:(NSNumber*)dailyValue
           withDate:(NSDate*)historicalDate
         ofVariable:(NSString*)variable {
    
    // turn value & date into a dictionary
    NSMutableDictionary* sampleDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        dailyValue, @"value",
                                        historicalDate, @"time",
                                        nil];
    
    // get a new saveKey for the daily sample
    NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"yyyyMMdd"];
    NSString* saveKey = [[NSString alloc] initWithString:[timeFormat stringFromDate:historicalDate]];
    
    // update dictionary of variable, then update the total DailyScores dictionary
    NSMutableDictionary* variableDict = [[NSMutableDictionary alloc] initWithDictionary:[self variableDict:variable]];
    [variableDict setValue:sampleDict forKey:saveKey];
    [self.dailyDict setValue:variableDict forKey:variable];
    
    [self saveDailyDict];
}

# pragma mark - getters

// Get the string of the path to DailyScores.plist
- (NSString*) pathOfPList {
    if (!_pathOfPList) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory =  [paths objectAtIndex:0];
        _pathOfPList = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"DailyScores.plist"]];
    }
    return _pathOfPList;
}

// Returns the complete daily dictionary.
- (NSMutableDictionary *) dailyDict {
    if (!_dailyDict)
        _dailyDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:self.pathOfPList] mutableCopy];
    return _dailyDict;
}

# pragma mark - dailyDict supporting functions

// 
- (BOOL) syncDailyDict {
    NSMutableDictionary *plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:self.pathOfPList] mutableCopy];

    if (![self.dailyDict isEqualToDictionary:plistDict]) {
        self.dailyDict = plistDict;
        return 1;
    }
    return 0;
}

// Save the daily dictionary.
- (void) saveDailyDict {
    BOOL writeSucces = [self.dailyDict writeToFile:self.pathOfPList atomically:YES];
    NSLog(@"saved DailyDict? %i", writeSucces);
}

@end

