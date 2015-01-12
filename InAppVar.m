//
//  InAppVar.m
//  Health
//
//  Created by Bas Oppenheim on 12-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "InAppVar.h"

@implementation InAppVar

@synthesize varName = _varName;
@synthesize lastRating = _lastRating;



- (NSString *)varName {
    if (!_varName)
        _varName = [NSString new];
        return _varName;
}

- (int)lastRating {
    if (!_lastRating)
        _lastRating = 0;
        return _lastRating;
}

@end