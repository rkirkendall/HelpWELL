//
//  ViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/13/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "JBChartView/JBChartView.h"
#import "JBChartView/JBBarChartView.h"
#import "JBChartView/JBLineChartView.h"
@interface DashboardViewController : UIViewController<UIActionSheetDelegate,JBLineChartViewDataSource,JBLineChartViewDelegate>

@property (weak, nonatomic) IBOutlet BButton *supportsButton;
@property (weak, nonatomic) IBOutlet BButton *resourcesButton;
@property (weak, nonatomic) IBOutlet BButton *activitiesButton;
@property (weak, nonatomic) IBOutlet BButton *needHelp;
@property (weak, nonatomic) IBOutlet BButton *rateYourDayButton;

// Rate your day
@property (weak, nonatomic) IBOutlet UIView *moodRaterView;
@property (weak, nonatomic) IBOutlet UISlider *moodSlider;
@property (weak, nonatomic) IBOutlet UISlider *anxietySlider;
@property (weak, nonatomic) IBOutlet UISlider *hoursSleptSlider;
@property (weak, nonatomic) IBOutlet UILabel *hoursSleptLabel;
- (IBAction)sliderMoved:(id)sender;
- (IBAction)sliderFinishedMoving:(id)sender;


- (IBAction)okayButtonTapped:(id)sender;
- (IBAction)rateYourDayButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *whatHappenedButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *okMoodRater;
- (IBAction)backADay:(id)sender;
- (IBAction)forwardADay:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (nonatomic, strong) NSDate *currentDate;
-(void)dismissJournalView;

//Graph
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) NSArray *lines;
@property (nonatomic, strong) NSArray *dateStrings;
@property (weak, nonatomic) IBOutlet UILabel *avgSleepLabel;

@end

