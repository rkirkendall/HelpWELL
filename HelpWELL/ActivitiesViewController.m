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

#define MaxActivityCount 5
#define AddAFavoriteActivity @"Add a favorite activity"
@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Activities";
//    UIBarButtonItem *addActivityButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showActivityPicker)];
//    self.navigationItem.rightBarButtonItem = addActivityButton;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.currentDate = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    [self setCurrentDatesActivities];
    self.activityDateLabel.text = @"Today";
    self.forwardButton.hidden = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void)setCurrentDatesActivities{
    self.favoriteActivities = [ActivitiesManager FavoriteActivities];
    self.activities = [ActivitiesManager ActivityLogForDate:self.currentDate];
    NSLog(@"Activities: %@", self.activities);
    NSLog(@"Fav. Activities: %@", self.favoriteActivities);
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
        [ActivitiesManager SetFavoriteActivity:self.pickedActivity atIndex:self.pickedActivityIndex];
        [self setCurrentDatesActivities];
    }
}

-(void)showActivityPicker{
    ActivitiesPickerViewController *activityPicker = [[ActivitiesPickerViewController alloc]init];
    activityPicker.parentVC = self;
    self.pickedActivity = nil;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:activityPicker];
    NSLog(@"presenting: %@",[NSDate date]);
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
    
    if (indexPath.row == self.favoriteActivities.count) {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:16.0f];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%lu left)", AddAFavoriteActivity,5 - self.favoriteActivities.count];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.textLabel.text = self.favoriteActivities[indexPath.row];
        
        NSString *favoriteActivity = self.favoriteActivities[indexPath.row];
        BOOL check = NO;
        for (NSString *act in self.activities) {
            if ([act isEqualToString:favoriteActivity]) {
                check = YES;
                break;
            }
        }
        if (check) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.favoriteActivities.count == 5) {
        return self.favoriteActivities.count;
    }else
        return self.favoriteActivities.count+1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.favoriteActivities = [ActivitiesManager DeleteFavoriteActivity:self.favoriteActivities[indexPath.row]];
        if (self.favoriteActivities.count == 4) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row <self.favoriteActivities.count) {
        //Checkmark
        NSString *selectedActivity = self.favoriteActivities[indexPath.row];
        BOOL alreadyListed = NO;
        for (NSString *act in self.activities) {
            if ([act isEqualToString:selectedActivity]) {
                alreadyListed = YES;
                break;
            }
        }
        if (alreadyListed) {
            [ActivitiesManager DeleteActivity:selectedActivity fromDate:self.currentDate];
        }else{
            [ActivitiesManager LogActivity:self.favoriteActivities[indexPath.row] onDate:self.currentDate];
        }        
        self.activities = [ActivitiesManager ActivityLogForDate:self.currentDate];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        self.pickedActivityIndex = indexPath.row;
        [self showActivityPicker];
    }
    
}



@end
