//
//  MoodTimeLabel.m
//  Health
//
//  Created by Bas Oppenheim on 29-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "MoodTimeLabel.h"

@implementation MoodTimeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showTime {
    [self setTextColor:[UIColor colorWithWhite:0 alpha:0.33]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFont:[UIFont systemFontOfSize:29]];
    
    NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    self.text = [timeFormat stringFromDate:[NSDate date]];
    
    [self animate];
}

- (void) animate {
    NSLog(@"animating");
    self.alpha = 0;
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.alpha = 0.5;
                         
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                               delay:0
                                             options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              self.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {}];
                     }];
    
}

@end
