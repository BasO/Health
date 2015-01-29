//
//  Statistics.h
//  Health
//
//  Created by Bas Oppenheim on 23-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//
//  The Statistics class is used to do statistical analysis on variables in the DailyScores.plist .
//  Currently only supports the Pearson correlation analysis.

#import <Foundation/Foundation.h>
#import "DailyScores.h"

@interface Statistics : NSObject

- (NSArray*) allVariables;

- (NSNumber*) pearsonCorrelationOfVariable1:(NSString*)variable1
                               andVariable2:(NSString*)variable2;

@end
