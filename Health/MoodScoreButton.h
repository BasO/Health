//
//  MoodScoreButton.h
//  Health
//
//  Created by Bas Oppenheim on 29-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodScoreButton : UIButton

@property (nonatomic) NSString* buttonEmoticon;
@property (nonatomic) NSString* buttonNumber;
@property (nonatomic) NSString* buttonLabel;
@property (nonatomic) int buttonValue;

- (void) setupWithValue:(int)buttonValue andEmoticonTitle:(NSString*)emoticon andNumberTitle:(NSString*)numberString andLabelTitle:(NSString*)label;
- (void) changeToEmoticon;
- (void) changeToNumber;
- (void) changeToLabel;

@end
