//
//  WaterViewController.h
//  Health
//
//  Created by Bas Oppenheim on 20-01-15.
//  Copyright (c) 2015 Bas Oppenheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPageViewController.h"
#import "PListFunctions.h"

@interface WaterViewController : UIViewController <MSPageViewControllerChild>


@property (weak, nonatomic) IBOutlet UILabel *drinkLabel;

@property (weak, nonatomic) IBOutlet UIButton *ml33Button;

@property (weak, nonatomic) IBOutlet UIButton *ml50Button;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;


@end