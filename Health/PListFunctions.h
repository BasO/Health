//
//  PListFunctions.h
//  Health
//
//  Created by Bas Oppenheim on 19-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListFunctions : NSObject

@property (nonatomic) NSMutableDictionary* inputDict;
@property (nonatomic) NSMutableDictionary* dailyDict;

- (NSMutableArray *)dailyDictKeysFor:(NSString*)variable;
- (NSMutableArray *)inputDictKeysFor:(NSString*)variable;

- (void)resetInputDict;
- (void)resetDailyDict;

- (NSMutableDictionary*) variableInputDict:(NSString*)variable;


- (void) writeInputValue:(NSNumber*)inputValue
                withDate:(NSDate*)historicalDate
              ofVariable:(NSString*)variable;

- (NSMutableDictionary*) variableDailyDict:(NSString*)variable;

- (void) writeDailyValue:(NSNumber*)dailyValue
                withDate:(NSDate*)historicalDate
              ofVariable:(NSString*)variable;

- (NSString*) pathOfPList:(NSString*)fileName;


@end
