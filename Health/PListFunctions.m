//
//  PListFunctions.m
//  Health
//
//  Created by Bas Oppenheim on 19-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "PListFunctions.h"

@implementation PListFunctions

- (NSDictionary*)allData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PsychologicalScores.plist"];
    
    NSLog(@"allData called");
    
    return [[[NSDictionary alloc] initWithContentsOfFile:path]mutableCopy];
}

- (NSDictionary*)variableDataFor:(NSString*)variable {
    return [[NSDictionary alloc] initWithDictionary:[[self allData] objectForKey:variable]];
}

- (NSString*) lastVariableIndexFor:(NSString*)variable {
    NSMutableArray*keys = [[NSMutableArray alloc] initWithArray:[[self variableDataFor:variable] allKeys]];
    
    [keys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [keys lastObject];
}

- (NSDictionary*) lastVariableInputFor:(NSString*)variable {
    return [[self variableDataFor:variable] objectForKey:[self lastVariableIndexFor:(NSString*)variable]];
}

- (NSDate*) inputTimeFor:(NSString*)variable ForIndex:(NSInteger)index {
    return [[[self variableDataFor:variable] objectForKey:[NSString stringWithFormat:@"%08i", (int)index]] objectForKey:@"time"];
}

- (NSNumber*) inputValueFor:(NSString*)variable ForIndex:(NSInteger)index {
    return [[[self variableDataFor:variable] objectForKey:[NSString stringWithFormat:@"%08i", (int)index]] objectForKey:@"value"];
}


@end
