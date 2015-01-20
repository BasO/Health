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

#pragma - resetters
- (void)resetInputDict {
    _inputDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:[self pathOfPList:@"InputScores.plist"]] mutableCopy];
}

- (void)resetDailyDict {
    _dailyDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:[self pathOfPList:@"DailyScores.plist"]] mutableCopy];
}


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


# pragma - DailyScores.plist functions



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


- (NSString*) pathOfPList:(NSString*)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


@end
