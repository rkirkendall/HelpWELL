//
//  ResourcesTableViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/29/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "ResourcesTableViewController.h"
#import "WebViewController.h"
#import "TriggerManager.h"
@interface ResourcesTableViewController ()

@end

@implementation ResourcesTableViewController
extern NSString * const URL_Key;
extern NSString * const Description_Key;
extern NSString * const Name_Key;
NSString * const URL_Key  = @"url_key";
NSString * const Description_Key  = @"description_key";
NSString * const Name_Key  = @"name_key";

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.resources)
    {
        self.title = @"Resources";
        self.resources = @[
                           @{Name_Key:@"The Carruth Center for Psychological and Psychiatric Services",
                             Description_Key:@"The Carruth Center is the student counseling center at West Virginia University. Tap to visit the Carruth Center website to learn how staff there can help.",
                             URL_Key:@"http://well.wvu.edu/ccpps"},
                           @{Name_Key:@"Learn How to Help Others At-Risk",
                             Description_Key:@"West Virginia University offers online training modules for students, faculty, and staff. Tap to visit the WELLWVU website where you can learn how to access and complete these helpful modules.",
                             URL_Key:@"http://well.wvu.edu/ccpps/suicide-awareness-and-prevention"},
                           @{Name_Key:@"Veterans Crisis Line Information",
                             Description_Key:@"The Veterans Crisis Center offers specialized resources and support to help veterans. Tap to visit the Veterans Crisis Center website.",
                             URL_Key:@"http://veteranscrisisline.net/"},
                           @{Name_Key:@"Trevor Project",
                             Description_Key:@"The Trevor Project offers specialized crisis and suicide prevention resources to help LGBTQ individuals. Tap to visit the Trevor Project website.",
                             URL_Key:@"http://www.thetrevorproject.org/"},
                           @{Name_Key:@"WELLWVU Resources for Depression/Anxiety",
                             Description_Key:@"Tap to visit the WELLWVU website for resources to help with depression and anxiety.",
                             URL_Key:@"http://well.wvu.edu/anxiety_depression"}];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkAlert];
}

-(void)checkAlert{
    NSDictionary *alert = [TriggerManager OpenedResources];
    if (alert) {
        NSString *title = alert[TM_Title];
        NSString *body = alert[TM_Body];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.resources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.resources[indexPath.row][Name_Key];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = self.resources[indexPath.row][Description_Key];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedResource = self.resources[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"webSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"webSegue"])
    {
        WebViewController *webController = (WebViewController *)segue.destinationViewController;
        webController.displayItem = self.selectedResource;
    }
}



@end
