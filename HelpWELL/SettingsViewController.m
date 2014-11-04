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
            //Set switch value based on model
        }
    }
    
    // Configure the cell
    NSString *cellText = self.sections[indexPath.section][SectionCells][indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = cellText;
    
    return cell;
}
@end
