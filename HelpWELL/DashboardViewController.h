//
//  ViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/13/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface DashboardViewController : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet BButton *supportsButton;
@property (weak, nonatomic) IBOutlet BButton *resourcesButton;
@property (weak, nonatomic) IBOutlet BButton *activitiesButton;
@property (weak, nonatomic) IBOutlet BButton *needHelp;
@property (weak, nonatomic) IBOutlet BButton *rateYourDayButton;
@property (weak, nonatomic) IBOutlet UIButton *whatHappenedButton;
@property (weak, nonatomic) IBOutlet UIButton *okMoodRater;
- (IBAction)backADay:(id)sender;
- (IBAction)forwardADay:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property(nonatomic, strong)NSString *journalText;

-(void)dismissJournalView;

@end

