//
//  SettingsViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/4/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "SettingsViewController.h"

#define SectionRows @"rows"
#define SectionTitle @"title"
#define SectionCells @"cells"

@interface SettingsViewController ()
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UITextField *timeTextField;
@end

@implementation SettingsViewController
NSString * const MoodSectionTitle  = @"Mood";
NSString * const ActivitiesSectionTitle  = @"Activities";
NSString * const AchievementsSectionTitle  = @"Achievements";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    if (!self.sections) {
        NSArray *moodCells = @[@"Enable Daily Reminders",@"Remind me on", @"Export via Email"];
        NSArray *activityCells = @[@"Enable Daily Reminders",@"Remind me on"];
        NSArray *achievementCells = @[@"View Achievements"];
        self.sections = @[@{SectionTitle:MoodSectionTitle, SectionCells:moodCells},
                          @{SectionTitle:ActivitiesSectionTitle, SectionCells:activityCells},
                          @{SectionTitle:AchievementsSectionTitle, SectionCells:achievementCells}];
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
    NSLog(@"ha!");
    if (aswitch.tag == 0) {
        //Mood
    }else if(aswitch.tag == 1){
        //Activities
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
            cell.detailTextLabel.text = @"hello";
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
            //Set switch value based on model
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
    if ((indexPath.section == 0 || indexPath.section == 1)&&(indexPath.row == 1)) {
        //Trigger time picker LOL
        
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
                                       [self parseTimeString:timeString];
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
}

\

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
        
        NSDate *toReturn = [NSDate date];
        if (amIndex != NSNotFound) {
            NSLog(@"AM");
            
            //[toReturn]
            
        }else{
            NSLog(@"PM");
        }
        
        //NSDate *toReturn =
        
        return [NSDate date];
    }
    
    
}

@end
