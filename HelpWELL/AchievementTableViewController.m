//
//  AchievementTableViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/10/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "AchievementTableViewController.h"
#import "TriggerManager.h"
@interface AchievementTableViewController ()

@end

@implementation AchievementTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Achievements";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [TriggerManager Achievements].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [TriggerManager Achievements][indexPath.row][TM_Title];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
