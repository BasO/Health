//
//  inputScores.h
//  Health
//
//  Created by Bas Oppenheim on 21-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
//  The InputScores class is used to read (in several formats) data and entries of InputScores.plist .
//  It can also write a new entry into InputScores.

#import <Foundation/Foundation.h>

@interface InputScores : NSObject

@property (nonatomic) NSMutableDictionary* inputDict;
@property (nonatomic) NSString* pathOfPList;

- (NSMutableDictionary*) variableDict:(NSString*)variable;

- (NSMutableArray *) saveKeysFor:(NSString*)variable;

- (NSDictionary*) inputCountAndTotalValueForDate:(NSDate*)historicalDate
                                     forVariable:(NSString*)variable;

- (NSNumber*) inputCountForDate:(NSDate*)historicalDate
                    forVariable:(NSString*)variable;

- (NSNumber*) totalValueForDate:(NSDate*)historicalDate
                    forVariable:(NSString*)variable;

- (NSNumber*) averageValueForDate:(NSDate*)historicalDate
                      forVariable:(NSString*)variable;

- (void) writeValue:(NSNumber*)inputValue
           withDate:(NSDate*)historicalDate
         ofVariable:(NSString*)variable;

- (NSString*) pathOfPList;

- (BOOL) syncInputDict;

- (void) saveInputDict;

@end
