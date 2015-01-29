//
//  inputScores.m
//  Health
//
//  Created by Bas Oppenheim on 21-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "InputScores.h"

@implementation InputScores

# pragma mark - read functions

// Returns the complete input for one variable.
- (NSMutableDictionary*) variableDict:(NSString*)variable {
    return [self.inputDict objectForKey:variable];
}

// Returns a sorted array of saveKeys in a variable.
- (NSMutableArray *) saveKeysFor:(NSString*)variable {
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[[self variableDict:variable] allKeys]] ;
    [tempArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return tempArray;
}

// Return a dictionary containing for one variable the inputs-count and total value for one date.
- (NSDictionary*) inputCountAndTotalValueForDate:(NSDate*)historicalDate
                                     forVariable:(NSString*)variable {
    float dayInputCount = 0;
    float dayInputTotal = 0;
    
    NSMutableDictionary* variableDict = [self variableDict:variable];
    
    for (id key in variableDict) {
        NSDictionary* sampleDict = [variableDict objectForKey:key];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        [gregorian setTimeZone:gmt];
        
        NSDateComponents *historicalDateComps = [gregorian components: NSUIntegerMax fromDate: historicalDate];
        NSDateComponents *keyDateComps = [gregorian components: NSUIntegerMax fromDate: [sampleDict valueForKey:@"time"]];
        
        if([historicalDateComps day] == [keyDateComps day] &&
           [historicalDateComps month] == [keyDateComps month] &&
           [historicalDateComps year] == [keyDateComps year] &&
           [historicalDateComps era] == [keyDateComps era]) {
            
            dayInputTotal += [[sampleDict valueForKey:@"value"] floatValue];
            dayInputCount += 1;
        }
    }
    
    NSDictionary* inputCountAndTotal = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:dayInputCount], @"count",
                                        [NSNumber numberWithFloat:dayInputTotal], @"total",
                                        nil];
    
    return inputCountAndTotal;
}

// Return for a variable the input-count for one date.
- (NSNumber*) inputCountForDate:(NSDate*)historicalDate
                        forVariable:(NSString*)variable {
    return [[self inputCountAndTotalValueForDate:historicalDate forVariable:variable] objectForKey:@"count"];
}

// Return for a variable the total value for one date.
- (NSNumber*) totalValueForDate:(NSDate*)historicalDate
                    forVariable:(NSString*)variable {
    return [[self inputCountAndTotalValueForDate:historicalDate forVariable:variable] objectForKey:@"total"];
}

// Return for a variable the average value for one date.
- (NSNumber*) averageValueForDate:(NSDate*)historicalDate
                    forVariable:(NSString*)variable {
    
    NSDictionary* inputCountAndTotal = [self inputCountAndTotalValueForDate:historicalDate forVariable:variable];    
    float inputCount = [[inputCountAndTotal objectForKey:@"count"] floatValue];
    float totalValue = [[inputCountAndTotal objectForKey:@"total"] floatValue];
    float averageValue = (totalValue / inputCount);
    return [NSNumber numberWithFloat:averageValue];
}


# pragma mark - write functions

// Write one input sample to input-dictionary.
- (void) writeValue:(NSNumber*)inputValue
           withDate:(NSDate*)historicalDate
         ofVariable:(NSString*)variable {
    
    // turn value & date into a dictionary
    NSMutableDictionary* sampleDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        inputValue, @"value",
                                        historicalDate, @"time",
                                        nil];
    
    // get a new saveKey for the input sample
    NSMutableArray* allKeys = [[NSMutableArray alloc] initWithArray:[self saveKeysFor:variable]];
    int lastSaveKey = [[allKeys lastObject] intValue];
    NSString* saveKey = [NSString stringWithFormat:@"%08i", (lastSaveKey + 1)];
    
    // update dictionary of variable, then update the total InputScores dictionary
    NSMutableDictionary* variableDict = [[NSMutableDictionary alloc] initWithDictionary:[self variableDict:variable]];
    [variableDict setValue:sampleDict forKey:saveKey];
    [self.inputDict setValue:variableDict forKey:variable];
    
    [self saveInputDict];
}



# pragma mark - inputDict supporting functions

// Update the inputDict with the plist-file. Give a message if a newer was found.
- (BOOL) syncInputDict {
    NSMutableDictionary *plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:self.pathOfPList] mutableCopy];
    if (![self.inputDict isEqualToDictionary:plistDict]) {
        self.inputDict = plistDict;
        return 1;
    }
    return 0;
}

# pragma mark - getters

// Get the string of the path to InputScores.plist
- (NSString*) pathOfPList {
    if (!_pathOfPList) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory =  [paths objectAtIndex:0];
        _pathOfPList = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"InputScores.plist"]];
    }
    return _pathOfPList;
}

// Returns the complete input dictionary.
- (NSMutableDictionary *) inputDict {
    if (!_inputDict) {
        _inputDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:self.pathOfPList] mutableCopy];
    }
    return _inputDict;
}

// Save the input dictionary.
- (void) saveInputDict {
    BOOL writeSucces = [self.inputDict writeToFile:self.pathOfPList atomically:YES];
}

@end
