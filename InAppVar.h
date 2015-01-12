//
//  InAppVar.h
//  Health
//
//  Created by Bas Oppenheim on 12-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppVar : NSObject

@property (nonatomic, copy) NSString *varName;
@property (nonatomic, assign) int lastRating;

@end
