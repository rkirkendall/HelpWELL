//
//  ViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/13/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface DashboardViewController : UIViewController

@property (weak, nonatomic) IBOutlet BButton *supportsButton;
@property (weak, nonatomic) IBOutlet BButton *resourcesButton;
@property (weak, nonatomic) IBOutlet BButton *activitiesButton;
@property (weak, nonatomic) IBOutlet BButton *needHelp;
@property (weak, nonatomic) IBOutlet BButton *rateYourDayButton;

@end

