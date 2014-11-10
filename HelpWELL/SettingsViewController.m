//
//  SettingsViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/4/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsManager.h"
#import "AchievementTableViewController.h"
#import "TriggerManager.h"
#import "CSVManager.h"

#define SectionRows @"rows"
#define SectionTitle @"title"
#define SectionCells @"cells"

@interface SettingsViewController ()
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, strong) NSString *moodDateString;
@property (nonatomic, strong) NSString *activityDateString;
@property (nonatomic, readwrite) BOOL moodEnabled;
@property (nonatomic, readwrite) BOOL activityEnabled;
@end

@implementation SettingsViewController
NSString * const MoodSectionTitle  = @"Mood";
NSString * const ActivitiesSectionTitle  = @"Activities";
NSString * const AchievementsSectionTitle  = @"Achievements";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    if (!self.sections) {
        NSArray *moodCells = @[@"Enable Daily Reminders",@"Remind me at", @"Export via Email"];
        NSArray *activityCells = @[@"Enable Daily Reminders",@"Remind me at"];
        NSArray *achievementCells = @[@"View Achievements"];
        self.sections = @[@{SectionTitle:MoodSectionTitle, SectionCells:moodCells},
                          @{SectionTitle:ActivitiesSectionTitle, SectionCells:activityCells},
                          @{SectionTitle:AchievementsSectionTitle, SectionCells:achievementCells}];
        [self loadFromSettingsManager];
    }

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSettingsView)];
    [self.navigationItem setLeftBarButtonItem:doneButton];
}

-(void)dismissSettingsView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sections[section][SectionTitle];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sections[section][SectionCells] count];
}

-(void)switchPressed:(UISwitch *)aswitch{
    if (aswitch.tag == 0) {
        //Mood
        [SettingsManager EnableDailyMoodReminders:aswitch.isOn];
    }else if(aswitch.tag == 1){
        //Activities
        [SettingsManager EnableDailyActivityReminders:aswitch.isOn];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        if ((indexPath.section == 0 || indexPath.section == 1)&&(indexPath.row == 1)) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            // add times to cells
            if (indexPath.section == 0) {
                cell.detailTextLabel.text = self.moodDateString;
            }else if(indexPath.section == 1){
                cell.detailTextLabel.text = self.activityDateString;
            }
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    // add switches to cells
    if ((indexPath.section == 0 ||indexPath.section == 1)) {
        
        if (indexPath.row == 0) {
            UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
            switchView.tag=indexPath.section;
            [switchView addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = switchView;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
            if (indexPath.section == 0) {
                if (self.moodEnabled) {
                    [switchView setOn:YES];
                }
                else{
                    [switchView setOn:NO];
                }
            }else if(indexPath.section == 1){
                if (self.activityEnabled) {
                    [switchView setOn:YES];
                }else{
                    [switchView setOn:NO];
                }
            }
        }
    }
    
    // Configure the cell
    NSString *cellText = self.sections[indexPath.section][SectionCells][indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = cellText;
    
    return cell;
}

-(void)addColon{
    if (self.timeTextField.isFirstResponder) {
        [self.timeTextField insertText:@":"];
    }
}
-(void)addPM{
    if (self.timeTextField.isFirstResponder) {
        [self.timeTextField insertText:@" PM"];
    }
}
-(void)addAM{
    if (self.timeTextField.isFirstResponder) {
        [self.timeTextField insertText:@" AM"];
    }
}

-(UIToolbar *)timeToolbar{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *colonButton =[[UIBarButtonItem alloc] initWithTitle:@":" style:UIBarButtonItemStylePlain target:self action:@selector(addColon)];
    UIBarButtonItem *pmButton = [[UIBarButtonItem alloc]initWithTitle:@"PM" style:UIBarButtonItemStylePlain target:self action:@selector(addPM)];
    UIBarButtonItem *amButton = [[UIBarButtonItem alloc]initWithTitle:@"AM" style:UIBarButtonItemStylePlain target:self action:@selector(addAM)];
    
    [toolbarItems addObject:pmButton];
    [toolbarItems addObject:colonButton];
    [toolbarItems addObject:pmButton];
    [toolbarItems addObject:amButton];
    
    toolbar.items = toolbarItems;
    
    return toolbar;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ((indexPath.section == 0 || indexPath.section == 1)&&(indexPath.row == 1)) {
        //Trigger time picker
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Remind me at"
                                              message: nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       UITextField *timeField = alertController.textFields.firstObject;
                                       
                                       NSString *timeString = timeField.text;
                                       
                                       // Do stuff
                                       NSDate *toSave = [self parseTimeString:timeString];
                                       if (indexPath.section == 0) {
                                           [SettingsManager SetMoodReminderTime:toSave];
                                       }else{
                                           [SettingsManager SetActivityReminderTime:toSave];
                                       }
                                       [self loadFromSettingsManager];
                                       UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                       if (indexPath.section == 0) {
                                           cell.detailTextLabel.text = self.moodDateString;
                                       }else if(indexPath.section == 1){
                                           cell.detailTextLabel.text = self.activityDateString;
                                       }
                                   }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             self.timeTextField = textField;
             textField.placeholder = @"5:00 PM";
             textField.keyboardType = UIKeyboardTypeNumberPad;
             textField.inputAccessoryView = [self timeToolbar];
         }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if(indexPath.section ==0 && indexPath.row == 2){
        // Export to csv via email
        NSString *csv = [CSVManager ExportAsCSV];
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"My HelpWELL data"];
        [controller setMessageBody:csv isHTML:NO];
        if (controller) {
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    }
    else if(indexPath.section == 2){
        NSLog(@"a: %@",[TriggerManager Achievements]);
        AchievementTableViewController *av = [[AchievementTableViewController alloc]init];
        [self.navigationController pushViewController:av animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadFromSettingsManager{
    NSDate *moodTime = [SettingsManager MoodReminderTime];
    NSDate *activityTime = [SettingsManager ActivityReminderTime];
    
    self.moodEnabled = [SettingsManager DailyMoodRemindersEnabled];
    self.activityEnabled = [SettingsManager DailyActivityRemindersEnabled];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setLocale:[[NSLocale alloc]
                   initWithLocaleIdentifier:@"en_US"]];
    [df setDateFormat:@"h:mm a"];
    self.moodDateString = [df stringFromDate:moodTime];
    self.activityDateString = [df stringFromDate:activityTime];
    [self.tableView reloadData];
}

-(NSDate *)parseTimeString:(NSString *)timeString{
    
    // Intermediate
    NSString *hourString;
    NSString *minuteString;
    
    NSInteger colonIndex = [timeString rangeOfString:@":"].location;
    
    if (colonIndex == NSNotFound) {
        return [NSDate date];
    }
    else{
        hourString = [timeString substringToIndex:colonIndex];
        minuteString = [timeString substringFromIndex:colonIndex+1];
        NSInteger amIndex = [minuteString rangeOfString:@"AM"].location;
        NSLog(@"%lu",amIndex);
        
        NSInteger spaceIndex = [minuteString rangeOfString:@" "].location;
        if (spaceIndex>=minuteString.length) {
            spaceIndex = minuteString.length;
        }
        minuteString = [minuteString substringToIndex:spaceIndex];
        
        NSInteger hours = [hourString integerValue];
        if (hours >11){
            hours = hours%12;
        }
        NSInteger minutes = [minuteString integerValue];
        if (minutes > 59) {
            minutes = minutes%60;
        }
        
        NSLog(@"[%lu : %lu]",hours, minutes);
        
        if (amIndex != NSNotFound) {
            NSLog(@"AM");
            
        }else{
            NSLog(@"PM");
            
            hours = hours+12;
        }
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setLocale:[[NSLocale alloc]
                               initWithLocaleIdentifier:@"en_US"]];
        [df setDateFormat:@"HH:mm:ss"];
        NSString *timeString = [NSString stringWithFormat:@"%02lu:%02lu:00",hours, minutes];
        NSDate *toReturn = [df dateFromString:timeString];
        NSLog(@"%@",[df stringFromDate:toReturn]);
        
        return toReturn;
    }
    
    
}

@end
