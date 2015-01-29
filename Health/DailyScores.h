//
//  dailyScores.h
//  Health
//
//  Created by Bas Oppenheim on 21-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
//  The InputScores class is used to read (in several formats) data and entries of DailyScores.plist .
//  It can also write a new entry into DailyScores.


#import <Foundation/Foundation.h>

@interface DailyScores : NSObject

@property (nonatomic) NSMutableDictionary* dailyDict;
@property (nonatomic) NSString* pathOfPList;

- (NSMutableDictionary*) variableDict:(NSString*)variable;

- (NSMutableArray *) saveKeysFor:(NSString*)variable;

- (NSNumber*) numberValueForSaveKey:(NSString*)saveKey ofVariable:(NSString*)variable;

- (void) writeValue:(NSNumber*)inputValue
           withDate:(NSDate*)historicalDate
         ofVariable:(NSString*)variable;

- (BOOL) syncDailyDict;
- (void) saveDailyDict;

@end
