//
//  PListFunctions.h
//  Health
//
//  Created by Bas Oppenheim on 19-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListFunctions : NSObject

- (NSDictionary*)allData;

- (NSDictionary*)variableDataFor:(NSString*)variable;

- (NSString*) lastVariableIndexFor:(NSString*)variable;

- (NSDictionary*) lastVariableInputFor:(NSString*)variable;

- (NSDate*) inputTimeFor:(NSString*)variable ForIndex:(NSInteger)index;

- (NSNumber*) inputValueFor:(NSString*)variable ForIndex:(NSInteger)index;

@end
