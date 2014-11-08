//
//  ActivitiesPickerTableViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/26/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "ActivitiesPickerViewController.h"
#import "ActivitiesManager.h"
@interface ActivitiesPickerViewController ()

@end

@implementation ActivitiesPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Activity";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parentVC action:@selector(dismissActivityPicker)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
    NSLog(@"loading table data: %@",[NSDate date]);
    self.tableData = [ActivitiesManager AllActivities];
    NSLog(@"loaded table data: %@",[NSDate date]);
    
    // Searh Bar stuff
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"Find or create new";
    self.definesPresentationContext = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        return [self.searchResults count]+1;
    } else {
        return [self.tableData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *cellData;
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        if(indexPath.row<self.searchResults.count){
            cellData = [self.searchResults objectAtIndex:indexPath.row];
        }else{
            cellData = [NSString stringWithFormat:@"Add '%@'",self.searchController.searchBar.text];
        }
        
    } else {
        cellData = [self.tableData objectAtIndex:indexPath.row];
    }
    
    // Configure the cell
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = cellData;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        if(indexPath.row>=self.searchResults.count){
            //Add the searched activity to custom activities
            NSString *newCustomActivity = self.searchController.searchBar.text;
            [ActivitiesManager SaveCustomActivity:newCustomActivity];
            self.parentVC.pickedActivity = newCustomActivity;
        }else{
            self.parentVC.pickedActivity = self.searchResults[indexPath.row];
        }
    }else{
        self.parentVC.pickedActivity = self.tableData[indexPath.row];
    }
    [self.parentVC dismissActivityPicker];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
    
    [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)activityName {
    
    // Update the filtered array based on the search text.
    if ((activityName == nil) || [activityName length] == 0) {
        // If there is no search string and the scope is "All".
        self.searchResults = [self.tableData mutableCopy];
        return;
    }
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    for (NSString *activity in self.tableData) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange productNameRange = NSMakeRange(0, activity.length);
        NSRange foundRange = [activity rangeOfString:activityName options:searchOptions range:productNameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:activity];
        }
    }
}


@end