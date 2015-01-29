//
//  MoodScoreButton.h
//  Health
//
//  Created by Bas Oppenheim on 29-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodScoreButton : UIButton

@property (nonatomic) NSString* emoticonTitle;
@property (nonatomic) NSString* numberTitle;
@property (nonatomic) NSString* labelTitle;
@property (nonatomic) int scoreValue;

@end
