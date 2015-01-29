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

// If button was pressed, quickly set alpha to 1 before changing to 0.5 again.
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
                                              completion:nil];
                         }];
    }
}

@end
