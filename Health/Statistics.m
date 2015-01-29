//
//  Statistics.m
//  Health
//
//  Created by Bas Oppenheim on 23-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "Statistics.h"


@implementation Statistics

DailyScores* dailyScores;

NSString* variable1;
NSString* variable2;
NSArray* variable1Keys;
NSArray* variable2Keys;
NSMutableArray* overlappingKeys;

- (id)init {
    self = [super init];
    if (self) {
        dailyScores = [[DailyScores alloc] init];
    }
    return self;
}

// Return the Pearson correlation between two variables.
- (NSNumber*) pearsonCorrelationOfVariable1:(NSString*)var1 andVariable2:(NSString*)var2 {
    [self setupParametersWithVariable:var1 andVariable:var2];

    // calculate the Pearson correlation
    float denominator = [overlappingKeys count] * [self productSum] - [self sumOfVariable:variable1] * [self sumOfVariable:variable2];
    float dividerPart1 = [overlappingKeys count] * [self powerSumOfVariable:variable1] - pow([self sumOfVariable:variable1], 2);
    float dividerPart2 = [overlappingKeys count] * [self powerSumOfVariable:variable2] - pow([self sumOfVariable:variable2], 2);
    float pearsonCorrelation = (denominator / sqrtf(dividerPart1 * dividerPart2));
    
    return [NSNumber numberWithFloat:pearsonCorrelation];
}

// Return ∑x where x is a value in variable for which date the other variable also has a value.
- (float) sumOfVariable:(NSString*)variable {
    float sum = 0;
    for (NSString* key in overlappingKeys) {
        sum += [[dailyScores numberValueForSaveKey:key ofVariable:variable] floatValue];
    }
    return sum;
}

// Returns ∑(x^2) where x is a value in variable for which date the other variable also has a value.
- (float) powerSumOfVariable:(NSString*)var {
    float sum = 0;
    
    for (NSString* key in overlappingKeys) {
        float keyValue = [[dailyScores numberValueForSaveKey:key ofVariable:var] floatValue];
        sum += pow(keyValue, 2);
    }
    return sum;
}

// Returns ∑(x * y) where x and y are values of different variables with the same date.
- (float) productSum {
    
    float totalProductSum = 0;
    
    for (NSString* key in overlappingKeys) {
        
        float value1 = [[dailyScores numberValueForSaveKey:key ofVariable:variable1] floatValue];
        float value2 = [[dailyScores numberValueForSaveKey:key ofVariable:variable2] floatValue];
        totalProductSum += (value1 * value2);
    }
    return totalProductSum;
}

// Returns an array of all variables that are contained in the DailyScores database.
- (NSArray*) allVariables {
    return [[dailyScores dailyDict] allKeys];
}

# pragma mark - helper functions


- (void) setupParametersWithVariable:(NSString*)var1 andVariable:(NSString*)var2 {
    
    variable1 = [[NSString alloc] initWithString:var1];
    variable2 = [[NSString alloc] initWithString:var2];
    variable1Keys = [[NSArray alloc] initWithArray:[dailyScores saveKeysFor:var1]];
    variable2Keys = [[NSArray alloc] initWithArray:[dailyScores saveKeysFor:var2]];
    
    // an array filled with saveKey-strings that are present in both variables
    overlappingKeys = [[NSMutableArray alloc] init];
    for (NSString* key in variable1Keys) {
        if ([variable2Keys containsObject:key]) {
            [overlappingKeys addObject:key];
        }
    }
}


@end
