//
//  waterProgress.m
//  Health
//
//  Created by Bas Oppenheim on 29-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import "WaterProgress.h"

@implementation WaterProgress

// Several functions to animate progress
- (void) setProgress:(float)progress {
    [UIView animateWithDuration:1
                          delay:0
                        options:
                                 UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionAllowAnimatedContent |
                                 UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         // update actual progress bar
                         [self setProgress:progress animated:YES];
                         
                         // keep hidden until progress bar is relevant
                         if (progress >= 0) {
                             self.hidden = NO;
                             self.alpha = 1;
                         }
                         else
                             self.alpha = 0;
                         
                         // show blue color while progress is incomplete
                         if (progress < 1) {
                             [self setProgressTintColor:[UIColor colorWithRed:184/255.0 green:232/255.0 blue:241/255.0 alpha:1]];
                         }
                     }
                     completion:^(BOOL finished) {
                         if (self.alpha == 0)
                             self.hidden = YES;
                         
                         // show yellow color once progress is (visibly) complete
                         if (self.progress >= 1) {
                             [UIView animateKeyframesWithDuration:3
                                                            delay:0
                                                          options:
                                                                      UIViewAnimationOptionAllowUserInteraction |
                                                                      UIViewAnimationOptionAllowAnimatedContent
                                                       animations:^{
                                                           [self setProgressTintColor:[UIColor colorWithRed:245/255.0 green:225/255.0 blue:10/255.0 alpha:1]];
                                                       }
                                                       completion:nil];
                         }
                        }];
}

@end
