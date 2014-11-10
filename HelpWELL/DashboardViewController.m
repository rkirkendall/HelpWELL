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
#import "TriggerManager.h"
#import "JBLineChartFooterView.h"
#import "JBChartHeaderView.h"


#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define kJBColorLineChartBackground UIColorFromHex(0x0079c1)


//CGFloat const kJBLineChartViewControllerChartHeight = 220.0f;
//CGFloat const kJBLineChartViewControllerChartPadding = 20.0f;
//CGFloat const kJBLineChartViewControllerChartHeaderHeight = 45.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 6.0f;
CGFloat const kJBLineChartViewControllerChartDashedLineWidth = 2.0f;
NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;

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
    
    [self setMoodRatings];
    self.dayLabel.text = @"Today";
    self.forwardButton.hidden = YES;
    [self reloadGraph];
}

-(void)viewDidAppear:(BOOL)animated{
    self.title = @"Dashboard";
    [self checkAlertOpenDashboard];
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://findtreatment.samhsa.gov/locator"]];
//        NSDictionary *samhsa = @{@"name_key":@"SAMHSA Behavioral Health Services Locator",
//                                 @"description_key":@"",
//                                 @"url_key":@"http://findtreatment.samhsa.gov/locator"};
//        
//        
//        UIStoryboard *storyboard = self.storyboard;
//        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//        WebViewController *webController =  (WebViewController *)vc;
//        webController.displayItem = samhsa;
//        
//        [self.navigationController pushViewController:webController animated:YES];
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
        [self.whatHappenedButton setTitle:@"What happened today?" forState:UIControlStateNormal];
        [self saveCurrentDatesMoodWithDescription:@""];
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
    [self reloadGraph];
}

- (IBAction)rateYourDayButton:(id)sender {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.currentDate = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    self.dayLabel.text = @"Today";
    [self setMoodRatings];
    self.forwardButton.hidden = YES;
    self.moodRaterView.hidden = NO;
}


-(void)saveCurrentDatesMoodWithDescription:(NSString *)desc{
    NSNumber *moodNumber = [NSNumber numberWithFloat:self.moodSlider.value *24];
    NSNumber *anxietyNumber = [NSNumber numberWithFloat:self.anxietySlider.value *24];
    NSNumber *sleepNumber = [NSNumber numberWithFloat:self.hoursSleptSlider.value *24];
    
    NSString *description = @"";
    if ([desc isEqualToString:@""]) {
        description =@"";
    }
    else if (!desc && !([[self.whatHappenedButton.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) && ![self.whatHappenedButton.titleLabel.text isEqualToString:@"What happened today?"]) {
        description = self.whatHappenedButton.titleLabel.text;
    }
    else{
        description = desc;
    }
    
    if (!description) {
        description =@"";
    }
    
    [MoodManager SaveMood:moodNumber anxiety:anxietyNumber sleep:sleepNumber withDescription:description forDate:self.currentDate];
    [self checkAlertLogMood];
    
}

-(void)checkAlertOpenDashboard{
    NSDictionary *alert = [TriggerManager OpenedDashboard];
    if (alert) {
        NSString *title = alert[TM_Title];
        NSString *body = alert[TM_Body];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)checkAlertLogMood{
    NSDictionary *alert = [TriggerManager LoggedMood];
    if (alert) {
        NSString *title = alert[TM_Title];
        NSString *body = alert[TM_Body];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
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

# pragma mark - Chart

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineChartView setState:JBChartViewStateExpanded];
}

-(void)initData{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.currentDate = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    
    NSDateFormatter *df = [MoodManager formatter];
    NSDictionary *moodData = [MoodManager GetMoods];
    
    // Do something else if they are in first week of install
    
    // Past 1 week, display the prev week data
    NSMutableArray *prevWeekDates = [NSMutableArray array];
    for (NSInteger i=6; i>-1; i--) {
        NSDate *toAdd = [self.currentDate dateByAddingTimeInterval:-60*60*24*(i)];
        [prevWeekDates addObject:toAdd];
    }
    
    NSMutableArray *sleepLine = [NSMutableArray array];
    NSMutableArray *anxietyLine = [NSMutableArray array];
    NSMutableArray *moodLine = [NSMutableArray array];
    
    NSMutableArray *strings = [NSMutableArray array];
    for (NSDate *day in prevWeekDates) {
        NSString *key = [df stringFromDate:day];
        [strings addObject:key];
        NSDictionary *dayData = moodData[key];
        if (!dayData) {
            dayData = @{MM_AnxietyKey:@12,MM_MoodKey:@12,MM_SleepKey:@12};
        }
        
        [sleepLine addObject:dayData[MM_SleepKey]];
        [anxietyLine addObject:dayData[MM_AnxietyKey]];
        [moodLine addObject:dayData[MM_MoodKey]];
    }
    self.lines = @[sleepLine, anxietyLine, moodLine];
    self.dateStrings = strings;
    
}

-(void)reloadGraph{
    [self initData];
    NSArray *sleepLine = self.lines[0];
    float sleepAvg = 0.0;
    for (NSNumber *hr in sleepLine) {
        NSLog(@"adding: %@",hr);
        sleepAvg+=hr.integerValue;
    }
    NSLog(@"dividing by: %lu",sleepLine.count);
    sleepAvg = sleepAvg/sleepLine.count;
    
    self.avgSleepLabel.text = [NSString stringWithFormat:@"AVG SLEEP THIS WEEK: %1.1f HRS",sleepAvg];
    
    [self.lineChartView reloadData];
}

- (void)loadView
{
    [super loadView];
    [self initData];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"height: %f",screenHeight);
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake([self ChartPadding], [self ChartPadding], self.view.bounds.size.width - ([self ChartPadding] * 2), [self ChartHeight]);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake([self ChartPadding], ceil(self.view.bounds.size.height * 0.5) - ceil([self HeaderHeight] * 0.5), self.view.bounds.size.width - ([self ChartPadding] * 2), kJBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = [[self.dateStrings firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[self.dateStrings lastObject] uppercaseString];;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = [[self dateStrings] count];
    self.lineChartView.footerView = footerView;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake([self ChartPadding], ceil(self.view.bounds.size.height * 0.5) - ceil([self HeaderHeight] * 0.5), self.view.bounds.size.width - ([self ChartPadding] * 2), [self HeaderHeight])];
    headerView.titleLabel.text = @"HelpWELL Monitor";
    //headerView.titleLabel.textColor = kJBColorLineChartHeader;
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    //headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;

    
    [self.graphView addSubview:self.lineChartView];
    
    [self.lineChartView reloadData];
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return self.lines.count;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [[self.lines objectAtIndex:lineIndex] count];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[[self.lines objectAtIndex:lineIndex] objectAtIndex:horizontalIndex] floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
//    NSNumber *valueNumber = [[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex];
//    [self.informationView setValueText:[NSString stringWithFormat:@"%.2f", [valueNumber floatValue]] unitText:kJBStringLabelMm];
//    [self.informationView setTitleText:lineIndex == JBLineChartLineSolid ? kJBStringLabelMetropolitanAverage : kJBStringLabelNationalAverage];
//    [self.informationView setHidden:NO animated:YES];
//    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
//    [self.tooltipView setText:[[self.daysOfWeek objectAtIndex:horizontalIndex] uppercaseString]];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
//    [self.informationView setHidden:YES animated:YES];
//    [self setTooltipVisible:NO animated:YES];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    if (lineIndex == 0) {
        return UIColorFromHex(0x00447c); //blue
        
    }else if(lineIndex == 1)
    {
        return UIColorFromHex(0xeeb111); //yellow
        //d9531e
    }else {
        return UIColorFromHex(0xf47b20);//orange
    }
    //return kJBColorLineChartDefaultSolidLineColor;
    //return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if (lineIndex == 0) {
        return UIColorFromHex(0x00447c); //blue
        
    }else if(lineIndex == 1)
    {
        return UIColorFromHex(0xeeb111); //yellow
        //d9531e
    }else {
        return UIColorFromHex(0xf47b20);//orange
    }
    
    //return kJBColorLineChartDefaultSolidLineColor;
    //    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return kJBLineChartViewControllerChartDashedLineWidth;
    //return (lineIndex == JBLineChartLineSolid) ? kJBLineChartViewControllerChartSolidLineWidth: kJBLineChartViewControllerChartDashedLineWidth;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (kJBLineChartViewControllerChartDashedLineWidth * 4);
    //return (lineIndex == JBLineChartLineSolid) ? 0.0: (kJBLineChartViewControllerChartDashedLineWidth * 4);
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return UIColorFromHex(0x00447c);
//    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    
    return UIColorFromHex(0x00447c);
//    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
    //return (lineIndex == JBLineChartLineSolid) ? JBLineChartViewLineStyleSolid : JBLineChartViewLineStyleDashed;
}

-(CGFloat) ChartPadding{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == 480) {
        return 10.0f;
    }
    else if(screenHeight == 568){
        return 10.0f;
    }
    else if(screenHeight == 667)
    {
        return 20.0f;
    }
    else //if(screenHeight == 736)
    {
        return 30.0f;
    }
}

-(CGFloat) ChartHeight{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == 480) {
        return 100.0f;
    }
    else if(screenHeight == 568){
        return 180.0f;
    }
    else if(screenHeight == 667)
    {
        return 220.0f;
    }
    else //if(screenHeight == 736)
    {
        return 250.0f;
    }
}

-(CGFloat) HeaderHeight{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == 480) {
        return 24.0f;
    }
    else if(screenHeight == 568){
        return 33.0f;
    }
    else if(screenHeight == 667)
    {
        return 45.0f;
    }
    else //if(screenHeight == 736)
    {
        return 55.0f;
    }
}

//header height - 480: 20 px

//667
//CGFloat const kJBLineChartViewControllerChartHeight = 220.0f;
//CGFloat const kJBLineChartViewControllerChartPadding = 20.0f;
//CGFloat const kJBLineChartViewControllerChartHeaderHeight = 45.0f;

//736
//CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
//CGFloat const kJBLineChartViewControllerChartPadding = 30.0f;
//CGFloat const kJBLineChartViewControllerChartHeaderHeight = 55.0f;

//480
//CGFloat const kJBLineChartViewControllerChartHeight = 100.0f;
//CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;
//CGFloat const kJBLineChartViewControllerChartHeaderHeight = 10.0f;

//568
//CGFloat const kJBLineChartViewControllerChartHeight = 200.0f;
//CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;
//CGFloat const kJBLineChartViewControllerChartHeaderHeight = 25.0f;


@end
