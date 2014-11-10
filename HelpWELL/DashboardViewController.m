//
//  ViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/13/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "DashboardViewController.h"
#import "JournalViewController.h"
#import "WebViewController.h"
#import "MoodManager.h"
@interface DashboardViewController ()
@property(nonatomic, strong)JournalViewController *journalController;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:2.0f]];
    [[BButton appearance] setStyle:BButtonStyleBootstrapV3];
    [[BButton appearance] setTitleColor:[UIColor colorWithRed:0 green:0.267 blue:0.486 alpha:1] forState:UIControlStateNormal];
    
    self.whatHappenedButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.rateYourDayButton setType:BButtonTypeSuccess];
    
    [self.needHelp setType:BButtonTypeDanger];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.currentDate = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    [self setMoodRatings];
    self.dayLabel.text = @"Today";
    self.forwardButton.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    self.title = @"Dashboard";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)needHelpNowTapped:(id)sender {
    UIActionSheet *contactAddActions = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Suicide Prevention Lifeline", @"SAMHSA Behavioral Health Services Locator", nil];
    [contactAddActions setTag:1];
    [contactAddActions showInView:self.view];

}


- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"Call..");
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"18002738255"]]];
        
    }else if(buttonIndex == 1){
        NSLog(@"Finder");
        NSDictionary *samhsa = @{@"name_key":@"SAMHSA Behavioral Health Services Locator",
                                 @"description_key":@"",
                                 @"url_key":@"http://findtreatment.samhsa.gov/locator"};
        
        
        UIStoryboard *storyboard = self.storyboard;
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        WebViewController *webController =  (WebViewController *)vc;
        webController.displayItem = samhsa;
        
        [self.navigationController pushViewController:webController animated:YES];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"journalSeg"]) {
        UINavigationController *nav = segue.destinationViewController;
        self.journalController = (JournalViewController *)nav.topViewController;
        self.journalController.parentVC = self;
        if (![self.whatHappenedButton.titleLabel.text isEqualToString:@"What happened today?"]) {
            
            self.journalController.initialText = self.whatHappenedButton.titleLabel.text;
        }
    }
}

- (IBAction)backADay:(id)sender {
    
    self.forwardButton.hidden = NO;
    self.currentDate = [self.currentDate dateByAddingTimeInterval:-60*60*24];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    
    if ([today isEqualToDate:self.currentDate]) {
        self.dayLabel.text = @"Today";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        self.dayLabel.text = [formatter stringFromDate:self.currentDate];
    }
    [self setMoodRatings];
}

- (IBAction)forwardADay:(id)sender {
    self.currentDate = [self.currentDate dateByAddingTimeInterval:60*60*24];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    if ([today isEqualToDate:self.currentDate]) {
        self.forwardButton.hidden = YES;
        self.dayLabel.text = @"Today";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        self.dayLabel.text = [formatter stringFromDate:self.currentDate];
    }
    [self setMoodRatings];
    
}

-(void)dismissJournalView{
    [self.journalController.textView resignFirstResponder];
    if (self.journalController.textView.text && ![[self.journalController.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self.whatHappenedButton setTitle:self.journalController.textView.text forState:UIControlStateNormal];
        [self saveCurrentDatesMoodWithDescription:self.journalController.textView.text];
    }
    else{
        [self saveCurrentDatesMoodWithDescription:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)sliderMoved:(id)sender {
    [self setHoursLabel];
}


- (IBAction)sliderFinishedMoving:(id)sender {
    NSLog(@"done - saving");
    [self saveCurrentDatesMoodWithDescription:nil];
}


- (IBAction)okayButtonTapped:(id)sender {
    self.moodRaterView.hidden = YES;
}

- (IBAction)rateYourDayButton:(id)sender {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.currentDate = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    self.dayLabel.text = @"Today";
    [self setMoodRatings];
    self.moodRaterView.hidden = NO;
}


-(void)saveCurrentDatesMoodWithDescription:(NSString *)desc{
    NSNumber *moodNumber = [NSNumber numberWithFloat:self.moodSlider.value *24];
    NSNumber *anxietyNumber = [NSNumber numberWithFloat:self.anxietySlider.value *24];
    NSNumber *sleepNumber = [NSNumber numberWithFloat:self.hoursSleptSlider.value *24];
    
    NSString *description = @"";
    if (!desc && !([[self.whatHappenedButton.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) && ![self.whatHappenedButton.titleLabel.text isEqualToString:@"What happened today?"]) {
        description = self.whatHappenedButton.titleLabel.text;
    }
    else{
        description = desc;
    }
    
    if (!description) {
        description =@"";
    }
    
    [MoodManager SaveMood:moodNumber anxiety:anxietyNumber sleep:sleepNumber withDescription:description forDate:self.currentDate];
}
-(void)setHoursLabel{
    NSNumber *h = [NSNumber numberWithFloat:self.hoursSleptSlider.value*24];
    self.hoursSleptLabel.text = [NSString stringWithFormat:@"%lu",(long)h.integerValue];
}

-(void)setMoodRatings{
    NSDictionary *moodData = [MoodManager MoodDataForDate:self.currentDate];
    
    NSNumber *moodNumber= moodData[MM_MoodKey];
    NSNumber *anxietyNumber= moodData[MM_AnxietyKey];
    NSNumber *sleepNumber= moodData[MM_SleepKey];
    NSString *description = moodData[MM_DescriptionKey];
    
    if (moodNumber) {
        [self.moodSlider setValue:(moodNumber.floatValue/24) animated:YES];
    }else{
        [self.moodSlider setValue:.5 animated:YES];
    }
    
    if (anxietyNumber) {
        [self.anxietySlider setValue:(anxietyNumber.floatValue/24) animated:YES];
    }else{
        [self.anxietySlider setValue:.5 animated:YES];
    }
    
    if (sleepNumber) {
        [self.hoursSleptSlider setValue:(sleepNumber.floatValue/24) animated:YES];
    }else{
        [self.hoursSleptSlider setValue:.5 animated:YES];
    }
    
        
    if (description && ![[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self.whatHappenedButton setTitle:description forState:UIControlStateNormal];
    }
    else{
        [self.whatHappenedButton setTitle:@"What happened today?" forState:UIControlStateNormal];
    }
    
    [self setHoursLabel];
}

@end
