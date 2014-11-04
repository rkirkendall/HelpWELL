//
//  ActivitiesViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/26/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "ActivitiesPickerViewController.h"
#import "ActivitiesManager.h"
@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Activities";
    UIBarButtonItem *addActivityButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showActivityPicker)];
    self.navigationItem.rightBarButtonItem = addActivityButton;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.currentDate = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    [self setCurrentDatesActivities];
    self.activityDateLabel.text = @"Today";
    self.forwardButton.hidden = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void)setCurrentDatesActivities{
    self.activities = [ActivitiesManager ActivityLogForDate:self.currentDate];
    NSLog(@"Activities: %@", self.activities);
    [self.tableView reloadData];
}

-(void)backADay{
    self.forwardButton.hidden = NO;
    self.currentDate = [self.currentDate dateByAddingTimeInterval:-60*60*24];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    
    if ([today isEqualToDate:self.currentDate]) {
        self.activityDateLabel.text = @"Today";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        self.activityDateLabel.text = [formatter stringFromDate:self.currentDate];
    }
    
    [self setCurrentDatesActivities];
}
-(void)forwardADay{
    self.currentDate = [self.currentDate dateByAddingTimeInterval:60*60*24];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    if ([today isEqualToDate:self.currentDate]) {
        self.forwardButton.hidden = YES;
        self.activityDateLabel.text = @"Today";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        self.activityDateLabel.text = [formatter stringFromDate:self.currentDate];
    }
    
    [self setCurrentDatesActivities];
}

- (IBAction)back:(id)sender {
    [self backADay];
}

- (IBAction)forward:(id)sender {
    [self forwardADay];
}

-(void)dismissActivityPicker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.pickedActivity){
        NSLog(@"%@",self.pickedActivity);
        [ActivitiesManager LogActivity:self.pickedActivity onDate:self.currentDate];
        [self setCurrentDatesActivities];
    }
}

-(void)showActivityPicker{
    ActivitiesPickerViewController *activityPicker = [[ActivitiesPickerViewController alloc]init];
    activityPicker.parentVC = self;
    self.pickedActivity = nil;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:activityPicker];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.activities[indexPath.row];
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activities.count;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.activities = [ActivitiesManager DeleteActivity:self.activities[indexPath.row] fromDate:self.currentDate];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
