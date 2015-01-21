//
//  PListFunctions.m
//  Health
//
//  Created by Bas Oppenheim on 19-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "PListFunctions.h"

@implementation PListFunctions

@synthesize inputDict = _inputDict;
@synthesize dailyDict = _dailyDict;

// TODO, (eventueel):
// instance variable van alldata
// constructor method

#pragma - getters
- (NSMutableDictionary *)inputDict {
    if (!_inputDict)
        _inputDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:[self pathOfPList:@"InputScores.plist"]] mutableCopy];
    return _inputDict;
}

- (NSMutableDictionary *)dailyDict {
    if (!_dailyDict)
        _dailyDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:[self pathOfPList:@"DailyScores.plist"]] mutableCopy];
    return _dailyDict;
}

#pragma - resetters
- (void)resetInputDict {
    _inputDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:[self pathOfPList:@"InputScores.plist"]] mutableCopy];
}

- (void)resetDailyDict {
    _dailyDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:[self pathOfPList:@"DailyScores.plist"]] mutableCopy];
}

#pragma - get dictionary keys
- (NSMutableArray *)inputDictKeysFor:(NSString*)variable {
    
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[[self variableInputDict:variable] allKeys]] ;
    [tempArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return tempArray;
}

- (NSMutableArray *)dailyDictKeysFor:(NSString*)variable {
    NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[[self variableDailyDict:variable] allKeys]] ;
    [tempArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSLog(@"dailyDictKeys are %@. First index is %@", tempArray, [tempArray objectAtIndex:0]);
    
    return tempArray;
}

# pragma - read/write variable of InputScores.plist

// Read variable in input-dictionary.
- (NSMutableDictionary*) variableInputDict:(NSString*)variable {
    return [[NSMutableDictionary alloc] initWithDictionary:[[self inputDict] objectForKey:variable]];
}

// Write one input score to input-dictionary.
- (void) writeInputValue:(NSNumber*)inputValue
                withDate:(NSDate*)historicalDate
              ofVariable:(NSString*)variable
{
    NSMutableDictionary* totalInputDict = [self inputDict];
    
    NSMutableDictionary* variableDict = [[NSMutableDictionary alloc] initWithDictionary:[totalInputDict
                                                                                       valueForKey:variable]];
    
    NSMutableDictionary* inputSample = [[NSMutableDictionary alloc] init];
    
    [inputSample setValue:inputValue forKey:@"value"];
    [inputSample setValue:historicalDate forKey:@"time"];
    
    NSMutableArray* allKeys = [[NSMutableArray alloc] initWithArray:[variableDict allKeys]];
    [allKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    int lastSaveKey = [[allKeys lastObject] intValue];
    NSString* saveKey = [NSString stringWithFormat:@"%08i", (lastSaveKey + 1)];
    
    [variableDict setValue:inputSample forKey:saveKey];
    
    [totalInputDict setValue:variableDict forKey:variable];
    
    NSLog(@"wrote InputDict? %i", [totalInputDict writeToFile:[self pathOfPList:@"InputScores.plist"] atomically:YES]);
}

// Return an array containing the number of inputs for one date, and the total value.
- (NSDictionary*) dailyInputCountAndTotalOfDate:(NSDate*)historicalDate
                                    forVariable:(NSString*)variable {
    float dailyInputCount = 0;
    float dailyInputTotal = 0;
    
    NSMutableDictionary* variableInputDict = [self variableInputDict:variable];
    
    for (id key in variableInputDict) {
        NSDictionary* saveKey = [variableInputDict objectForKey:key];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        [gregorian setTimeZone:gmt];
        NSDateComponents *dateComps = [gregorian components: NSUIntegerMax fromDate: historicalDate];
        NSDateComponents *dictDateComps = [gregorian components: NSUIntegerMax fromDate: [saveKey valueForKey:@"time"]];
        
        if([dateComps day] == [dictDateComps day] &&
           [dateComps month] == [dictDateComps month] &&
           [dateComps year] == [dictDateComps year] &&
           [dateComps era] == [dictDateComps era]) {
            
            dailyInputTotal += [[saveKey valueForKey:@"value"] floatValue];
            dailyInputCount += 1;
            
        }
        else
            break;
    }
    
    NSDictionary* inputCountAndTotal = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:dailyInputCount], @"count",
                                        [NSNumber numberWithFloat:dailyInputTotal], @"total",
                                        nil];
    
    return inputCountAndTotal;
}


# pragma - read/write DailyScores.plist



// Read variable in daily-dictionary.
- (NSMutableDictionary*) variableDailyDict:(NSString*)variable {
    return [[NSMutableDictionary alloc] initWithDictionary:[[self dailyDict] objectForKey:variable]];
}

// Write a daily score to daily-dictionary.
- (void) writeDailyValue:(NSNumber*)dailyValue
           withDate:(NSDate*)historicalDate
         ofVariable:(NSString*)variable
{
    NSMutableDictionary* totalDailyDict = [self dailyDict];
    
    NSMutableDictionary* variableDict = [[NSMutableDictionary alloc] initWithDictionary:[totalDailyDict
                                                                                         valueForKey:variable]];
    
    NSMutableDictionary* dailySample = [[NSMutableDictionary alloc] init];
    
    [dailySample setValue:dailyValue forKey:@"value"];
    [dailySample setValue:historicalDate forKey:@"time"];
    
    NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"YYYYMMdd"];
    NSString* saveKey = [[NSString alloc] initWithString:[timeFormat stringFromDate:historicalDate]];
    
    [variableDict setValue:dailySample forKey:[NSString stringWithString:saveKey]];
    
    [totalDailyDict setValue:variableDict forKey:variable];
    
    NSLog(@"totaldailydict is %@", totalDailyDict);
    
    NSLog(@"wrote DailyDict? %i", [totalDailyDict writeToFile:[self pathOfPList:@"DailyScores.plist"] atomically:YES]);
}

// Write as daily score the average value of one day in InputScores.plist
- (void) writeDailyAverageOfDate:(NSDate*)historicalDate
                      ofVariable:(NSString*)variable {
    
    NSDictionary* dailyInputCountAndTotal = [[NSDictionary alloc] initWithDictionary:[self dailyInputCountAndTotalOfDate:historicalDate forVariable:variable]];
    float dailyAverage = ([[dailyInputCountAndTotal objectForKey:@"total"] floatValue] /
                          [[dailyInputCountAndTotal objectForKey:@"count"] floatValue]);
    [self writeDailyValue:[NSNumber numberWithFloat:dailyAverage] withDate:historicalDate ofVariable:variable];
    
}

// Write as daily score the total value of one day in InputScores.plist
- (void) writeDailyTotalOfDate:(NSDate*)historicalDate
                    ofVariable:(NSString*)variable {
    
    NSDictionary* dailyInputCountAndTotal = [[NSDictionary alloc] initWithDictionary:[self dailyInputCountAndTotalOfDate:historicalDate forVariable:variable]];
    [self writeDailyValue:[dailyInputCountAndTotal objectForKey:@"total"] withDate:historicalDate ofVariable:variable];
}

# pragma - other

// Return the path of a .plist-file.
- (NSString*) pathOfPList:(NSString*)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}





@end
