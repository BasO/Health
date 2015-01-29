//
//  MoodScoreButton.m
//  Health
//
//  Created by Bas Oppenheim on 29-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "MoodScoreButton.h"

@implementation MoodScoreButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize buttonEmoticon = _buttonEmoticon;

- (void) setupWithValue:(int)value andEmoticonTitle:(NSString*)emoticon andNumberTitle:(NSString*)numberString andLabelTitle:(NSString*)label {
    self.buttonValue = value;
    self.buttonEmoticon = emoticon;
    self.buttonNumber = numberString;
    self.buttonLabel = label;
}

- (void) changeToEmoticon {
    [self setTitle:self.buttonEmoticon forState:UIControlStateNormal];
}

- (void) changeToNumber {
    [self setTitle:self.buttonNumber forState:UIControlStateNormal];
}

- (void) changeToLabel {
    [self setTitle:self.buttonLabel forState:UIControlStateNormal];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    BOOL touchedUpInside = NO;
    if (self.touchInside) {
        touchedUpInside = YES;
    }
    
    [super touchesEnded:touches withEvent:event];
    
    if (touchedUpInside) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:0.7
                                                 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                                              animations:^{
                                                  self.alpha = 0.5;
                                              }
                                              completion:^(BOOL finished) {}];
                         }];
    }
}

@end
